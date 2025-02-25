# list_files.gd
extends SceneTree

func _init():
    var dir = DirAccess.open("res://")
    if dir:
        print("Listing files in: res://")
        list_files_recursive(dir, "res://")
    else:
        print("Failed to open directory: res://")
    
    # 退出 Godot 引擎
    quit()

func list_files_recursive(dir: DirAccess, path: String):
    dir.list_dir_begin()
    var file_name = dir.get_next()
    
    while file_name != "":
        if file_name != "." and file_name != "..":
            var full_path = path + file_name
            if dir.current_is_dir():
                print("Directory: ", full_path)
                var subdir = DirAccess.open(full_path)
                if subdir:
                    list_files_recursive(subdir, full_path + "/")
                    subdir = null
            else:
                print("File: ", full_path)
        file_name = dir.get_next()
    
    dir.list_dir_end()