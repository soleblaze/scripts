#!/usr/bin/env python3

import os
import sys
import requests
import todoist
import yaml


def connect():
    """ Connect to todoist """
    # Get API Token for todoist
    fh = open(os.path.expanduser("~/.todoist.yml"), "r")
    config = yaml.load(fh)
    fh.close()

    # Connect to todoist
    api = todoist.TodoistAPI()
    user = api.user.login(config['user'], config['password'])

    if user.get('error_code'):
        code = user.get('error_code')
        msg = user.get('error')
        print("Error {}: {}".format(code, msg))
        exit(1)

    return api

def help():
    help = "add [project] [task] - adds task to project\n"
    help += "list - lists all projects and their items\n"
    help += "list [project] - lists items associated with that project\n"
    help += "projects - lists projects"
    print(help)
    exit(0)

def get_proj_id(api, project):
    resp = api.sync()
    # Get ID for project if it exists
    for resp_project in resp['projects']:
        if resp_project['name'].lower() == project.lower():
            project_id = resp_project['id']
    try:
        return project_id
    except NameError:
        return None

def add_task(api, project_id, task):
    item = api.items.add(task, project_id)
    commit = api.commit()
    print("Task added")

def create_project(api, name):
    resp = todoist.projects.add(name)
    commit = api.commit()
    print("Created Project: {}".format(name))

    return get_proj_id(api, name)

def list_all_tasks(api):
    resp = api.sync()
    projects = {}
    tasks = {}
    for project in resp['projects']:
        name = project['name']
        id = project['id']
        projects[id] = name

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
    resp = api.sync()
    tasks = []
    project_id  = ''
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
    resp = api.sync()
    projects = []
    for project in resp['projects']:
        projects.append(project['name'])

    projects.sort(key=lambda y: y.lower())
    print("\n".join(projects))

if __name__ == "__main__":
    if len(sys.argv) == 1:
        help()
    todoist = connect()

    action = sys.argv[1]

    if action == 'add':
        if len(sys.argv) < 3:
            help()
        project_name = sys.argv[2]
        task = ' '.join(sys.argv[3:])
        project_id = get_proj_id(todoist, project_name)
        if not project_id:
            project_id = create_project(todoist, project_name)
        add_task(todoist, project_id, task)
    elif action == 'list':
        if len(sys.argv) == 2:
            list_all_tasks(todoist)
        else:
            project = " ".join(sys.argv[2:])
            list_tasks(todoist, project)
    elif action == 'projects':
        list_projects(todoist)
    else:
      help()
