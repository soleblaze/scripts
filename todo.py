#!/usr/bin/env python3
""" lists and adds tasks to todoist """

import os
import sys
import todoist
import yaml


def connect():
    """ Connect to todoist """
    # Get API Token for todoist
    config_file = open(os.path.expanduser("~/.todoist.yml"), "r")
    config = yaml.load(config_file)
    config_file.close()

    # Connect to todoist
    api = todoist.TodoistAPI()
    user = api.user.login(config['user'], config['password'])

    if user.get('error_code'):
        code = user.get('error_code')
        msg = user.get('error')
        print("Error {}: {}".format(code, msg))
        exit(1)
    return api


def print_help():
    """ Prints out help """
    msg = "add [project] [task] - adds task to project\n"
    msg += "list - lists all projects and their items\n"
    msg += "list [project] - lists items associated with that project\n"
    msg += "projects - lists projects"
    print(msg)
    exit(0)


def get_proj_id(api, project):
    """ Takes the api object and a project name and returns its id """
    resp = api.sync()
    # Get ID for project if it exists
    for resp_project in resp['projects']:
        if resp_project['name'].lower() == project.lower():
            project_id = resp_project['id']
    try:
        return project_id
    except NameError:
        return None


def add_task(api, project_name, task):
    """ Takes a todoist api object, the project name, and the task and adds
    the task to todoist """

    project_id = get_proj_id(todoist, project_name)
    if not project_id:
        project_id = create_project(todoist, project_name)
    api.items.add(task, project_id)
    api.commit()
    print("Task added")


def create_project(api, name):
    """ Takes the api and the name of a project and creates it and returns
    the new project's id """
    api.projects.add(name)
    api.commit()
    print("Created Project: {}".format(name))

    return get_proj_id(api, name)


def list_all_tasks(api):
    """ Takes the api and Returns a list of all tasks """
    resp = api.sync()
    projects = {}
    tasks = {}
    for project in resp['projects']:
        name = project['name']
        project_id = project['id']
        projects[project_id] = name

    for item in resp['items']:
        if item['is_deleted']:
            break
        if item['in_history']:
            break

        project_id = item['project_id']
        project_name = projects[project_id]
        content = item['content']
        if project_name in tasks:
            tasks[project_name].append(content)
        else:
            tasks[project_name] = [content]

    for project, tasks in tasks.items():
        for task in tasks:
            print("{} - {}".format(project, task))


def list_tasks(api, project):
    """ Takes the api and project name and returns the tasks associated with
    that project """
    resp = api.sync()
    tasks = []
    project_id = ''
    for resp_project in resp['projects']:
        if resp_project['name'].lower() == project.lower():
            project_id = resp_project['id']

    if not project_id:
        print("No project named {}".format(project))
        exit(0)
    for item in resp['items']:
        if item['is_deleted']:
            break
        if item['in_history']:
            break

        if item['project_id'] == project_id:
            tasks.append(item['content'])

    print("\n".join(tasks))
    return


def list_projects(api):
    """ Takes the API object and prints a list of projects """
    resp = api.sync()
    projects = []
    for project in resp['projects']:
        projects.append(project['name'])

    projects.sort(key=lambda y: y.lower())
    print("\n".join(projects))


if __name__ == "__main__":
    if len(sys.argv) == 1:
        print_help()
    API = connect()
    ACTION = sys.argv[1]

    if ACTION == 'add':
        if len(sys.argv) < 3:
            print_help()
        add_task(API, sys.argv[2], ' '.join(sys.argv[3:]))
    elif ACTION == 'list':
        if len(sys.argv) == 2:
            list_all_tasks(API)
        else:
            list_tasks(API, ' '.join(sys.argv[2:]))
    elif ACTION == 'projects':
        list_projects(API)
    else:
        print_help()
