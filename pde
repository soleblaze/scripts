#!/bin/bash

module="$1"
module_dir="${HOME}/git/puppet/modules/${module}"

if [[ ! -d "${module_dir}" ]]; then
    echo "Error: ${module} is not in the puppet modules directory."
    exit 1
fi

tmux new-session -d -c "${module_dir}" -s "${module}" -n "${module}" "bundle exec guard"
tmux move-window -s "${module}:1" -t "${module}:2"
guard_pid=""
while [ ! "$guard_pid" ]; do
    guard_pid="$(pgrep -n guard)"
    sleep .5
done
tmux new-window  -c "${module_dir}" -t "${module}:1" -n "editor" "nvim;kill ${guard_pid}"
tmux switch -t "${module}"
