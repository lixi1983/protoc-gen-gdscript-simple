extends SceneTree

# 实现功能是通过Godot 命令行调用, 加载命令行参数中指定的脚本或目录， 测试脚本语法是否正常
func _init():
    var args = OS.get_cmdline_args()
    print("Args: ", args)
    
    # 跳过第一个参数（它是 --script）和第二个参数（它是 syntax_check.gd）
    if args.size() <= 2:
        print("ERROR: Please provide a script path or directory to check")
        quit(1)
    
    var path = args[2]  # 第三个参数是要检查的路径
    if not path.begins_with("res://"):
        path = "res://" + path
        
    var error_count = 0
    if path.ends_with(".gd"):
        # 检查单个文件
        print("\nChecking script: ", path)
        var script = load(path)
        if script == null:
            print("ERROR: Failed to load script: ", path)
            error_count += 1
        else:
            print("Script loaded successfully: ", path)
    else:
        # 检查整个目录
        print("\nChecking directory: ", path)
        error_count = check_directory(path)
    
    if error_count > 0:
        print("\nFound ", error_count, " files with syntax errors")
        quit(1)
    else:
        print("\nAll GDScript files passed syntax check")
        quit(0)

# 递归检查目录中的所有 .gd 文件
func check_directory(path: String) -> int:
    var error_count = 0
    var dir = DirAccess.open(path)
    if dir == null:
        print("ERROR: Failed to open directory: ", path)
        return 1
        
    dir.list_dir_begin()
    var file_name = dir.get_next()
    
    while file_name != "":
        var full_path = path + "/" + file_name
        if dir.current_is_dir() and not file_name.begins_with("."):
            # 递归检查子目录
            error_count += check_directory(full_path)
        elif file_name.ends_with(".gd"):
            # 检查 GDScript 文件
            print("\nChecking script: ", full_path)
            var script = load(full_path)
            if script == null:
                print("ERROR: Failed to load script: ", full_path)
                error_count += 1
            else:
                print("Script loaded successfully: ", full_path)
        
        file_name = dir.get_next()
    
    dir.list_dir_end()
    return error_count
