# hello_world.gd
extends SceneTree

var d = preload("res://demo.gd")

var dd = d.new()

class Bd extends d.Demo1:
    pass
    func _init():
        print("Bd")

func _init():
    print("Hello World")
    var dd = d.new()

    d.Demo1.new()
    d.Demo2.new()
    
    quit()  # 退出 Godot 引擎