#!/usr/bin/env python3

import os
import subprocess
import sys

def run_protoc(proto_file, output_dir):
    """运行protoc编译器生成GDScript文件"""
    cmd = [
        'protoc',
        f'--gdscript_out={output_dir}',
        f'-I{os.path.dirname(proto_file)}',
        proto_file
    ]
    
    result = subprocess.run(cmd, capture_output=True, text=True)
    if result.returncode != 0:
        print(f"Error generating GDScript for {proto_file}:")
        print(result.stderr)
        return False
    return True

def verify_output(output_dir, expected_files):
    """验证生成的文件是否存在且内容合理"""
    for file in expected_files:
        file_path = os.path.join(output_dir, file)
        if not os.path.exists(file_path):
            print(f"Error: Expected file {file} not found")
            return False
        
        with open(file_path, 'r') as f:
            content = f.read()
            if not content or len(content) < 10:
                print(f"Error: File {file} appears to be empty or too small")
                return False
            
            if "extends RefCounted" not in content:
                print(f"Error: File {file} doesn't contain expected GDScript class definition")
                return False
    
    return True

def main():
    # 创建输出目录
    output_dir = "test/proto3/generated"
    os.makedirs(output_dir, exist_ok=True)
    
    # 测试文件和期望生成的文件
    test_cases = [
        {
            'proto': 'test/proto3/test.proto',
            'expected_files': [
                'ChatMessage.gd',
                'ChatRoom.gd'
            ]
        }
    ]
    
    success = True
    
    for test_case in test_cases:
        print(f"\nTesting {test_case['proto']}...")
        
        # 生成GDScript文件
        if not run_protoc(test_case['proto'], output_dir):
            success = False
            continue
        
        # 验证生成的文件
        if not verify_output(output_dir, test_case['expected_files']):
            success = False
            continue
        
        print(f"Successfully generated GDScript files for {test_case['proto']}")
    
    if success:
        print("\nAll tests passed successfully!")
        sys.exit(0)
    else:
        print("\nSome tests failed!")
        sys.exit(1)

if __name__ == '__main__':
    main()
