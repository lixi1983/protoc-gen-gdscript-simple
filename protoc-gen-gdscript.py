#!/usr/bin/env python3

import sys
from google.protobuf.compiler import plugin_pb2
from generate_message import generate_gdscript

def main():
    """主函数"""
    try:
        # 从标准输入读取请求
        data = sys.stdin.buffer.read()
        request = plugin_pb2.CodeGeneratorRequest()
        request.ParseFromString(data)
        
        print("Starting GDScript code generator...", file=sys.stderr)

        # 生成代码
        response = generate_gdscript(request)
        
        print("end GDScript code generator...", file=sys.stderr)
        
        # 写入响应
        sys.stdout.buffer.write(response.SerializeToString())
        return 0
        
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        import traceback
        traceback.print_exc(file=sys.stderr)
        response = plugin_pb2.CodeGeneratorResponse()
        response.error = str(e)
        sys.stdout.buffer.write(response.SerializeToString())
        return 1

if __name__ == "__main__":
    sys.exit(main())
