#!/bin/bash

TODO_DIR="$HOME/.local/todo"

# Function to display the header
display_header() {
    clear
    figlet -c -f slant "Bash ToDo"
    figlet -s -f digital "A terminal appointment organizer"
    printf "\n "
    printf "                 created by :- Chiranjeev\n"
    printf "\n "
}

# Function to display the footer
display_footer() {
    printf "\nWould you like to add, view, edit, delete, mark completed, or exit?\n"
    printf "(A/a=add, V/v=view, E/e=edit, D/d=delete, M/m=mark completed, X/x=exit)\n"
    printf ": "
}

# Function to prompt user input
prompt_user() {
    printf "Please Make a Selection\n(options: A/a=add, V/v=view, E/e=edit, D/d=delete, M/m=mark completed, & X/x=exit)\n"
    printf " : "
    read -r answer
}

# Function to create the ToDo directory if it doesn't exist
create_todo_directory() {
    if [ ! -d "$TODO_DIR" ]; then
        mkdir -p "$TODO_DIR"
    fi
}

# Function to add a task
add_task() {
    create_todo_directory

    printf "\n"
    read -p "Enter the date for the tasks (format: Dec12): " date
    task_file="$TODO_DIR/$date"

    if [ -f "$task_file" ]; then
        printf "\nTasks for $date:\n"
        awk '{printf "%d. %s\n", NR, $0}' "$task_file"
    fi

    printf "\nEnter your tasks (one task per line; format: HH:MM AM/PM - task content):\n"
    printf "Press Ctrl+D when you're done.\n"
    
    # Read tasks from the user input
    tasks=()
    while IFS= read -r line; do
        tasks+=("$line")
    done

    # Append tasks to the task file
    for task in "${tasks[@]}"; do
        echo "$task" >> "$task_file"
    done

    printf "\nTasks added successfully!\n"
}


# Function to view tasks for a specific date
view_tasks() {
    create_todo_directory

    printf "\n"
    read -p "Enter the date to view tasks (format: Dec12): " date
    task_file="$TODO_DIR/$date"

    if [ -f "$task_file" ]; then
        printf "\nTasks for $date:\n"
        cat "$task_file"
    else
        printf "\nNo tasks found for $date.\n"
    fi
}

# Function to edit tasks
edit_tasks() {
    create_todo_directory

    printf "\n"
    read -p "Enter the date to edit tasks (format: Dec12): " date
    task_file="$TODO_DIR/$date"

    if [ -f "$task_file" ]; then
        # Display tasks with numbers
        awk '{printf "%d. %s\n", NR, $0}' "$task_file"

        # Prompt user to enter the number of the task to edit
        read -p "Enter the number of the task to edit: " task_number

        if [[ $task_number =~ ^[0-9]+$ ]] && [ "$task_number" -gt 0 ]; then
            # Prompt user to enter the updated content for the selected task
            read -p "Enter the updated task content: " updated_content

            # Edit the selected task
            sed -i "${task_number}s/.*/$updated_content/" "$task_file"
            printf "\nTask updated successfully!\n"
        else
            printf "\nInvalid input. No task updated.\n"
        fi
    else
        printf "\nNo task found for $date.\n"
    fi
}


# Function to delete tasks
delete_task() {
    create_todo_directory

    printf "\n"
    read -p "Enter the date to delete tasks (format: Dec12): " date
    task_file="$TODO_DIR/$date"

    if [ -f "$task_file" ]; then
        # Display tasks with numbers
        awk '{printf "%d. %s\n", NR, $0}' "$task_file"

        # Prompt user to enter the number of the task to delete
        read -p "Enter the number of the task to delete: " task_number

        if [[ $task_number =~ ^[0-9]+$ ]] && [ "$task_number" -gt 0 ]; then
            # Delete the selected task
            sed -i "${task_number}d" "$task_file"
            printf "\nTask deleted successfully!\n"
        else
            printf "\nInvalid input. No task deleted.\n"
        fi
    else
        printf "\nNo tasks found for $date.\n"
    fi
}



# Function to mark tasks as completed
mark_completed() {
    create_todo_directory

    printf "\n"
    read -p "Enter the date to mark tasks as completed (format: Dec12): " date
    task_file="$TODO_DIR/$date"

    if [ -f "$task_file" ]; then
        # Display tasks with numbers
        awk '{printf "%d. %s\n", NR, $0}' "$task_file"

        # Prompt user to enter the number of the task to mark as completed
        read -p "Enter the number of the task to mark as completed: " task_number

        if [[ $task_number =~ ^[0-9]+$ ]] && [ "$task_number" -gt 0 ]; then
            # Mark the selected task as completed
            sed -i "${task_number}s/^[^ ]* /[Completed] &/" "$task_file"
            printf "\nTask marked as completed!\n"
        else
            printf "\nInvalid input. No task marked as completed.\n"
        fi
    else
        printf "\nNo tasks found for $date.\n"
    fi
}


# Main program
while true; do
    display_header
    prompt_user

    case "$answer" in
        [Aa])
            add_task
            ;;
        [Vv])
            view_tasks
            ;;
        [Ee])
            edit_tasks
            ;;
        [Dd])
            delete_task
            ;;
        [Mm])
            mark_completed
            ;;
        [Xx])
            exit
            ;;
        *)
            printf "Please make proper selection\n"
            ;;
    esac

    display_footer
    read -r decision

    if [ "$decision" == "X" ] || [ "$decision" == "x" ]; then
        exit
    fi
done

