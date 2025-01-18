#!/usr/bin/env python3

import os
import subprocess
import sys

def run_test(test_script):
    """运行测试脚本"""
    print(f"\nRunning {test_script}...")
    result = subprocess.run(['python3', test_script], capture_output=True, text=True)
    print(result.stdout)
    if result.stderr:
        print(result.stderr)
    return result.returncode == 0

def main():
    # 获取当前目录
    current_dir = os.path.dirname(os.path.abspath(__file__))
    
    # 测试脚本列表
    test_scripts = [
        os.path.join(current_dir, 'proto2/test_generator.py'),
        os.path.join(current_dir, 'proto3/test_generator.py')
    ]
    
    success = True
    
    for test_script in test_scripts:
        if not run_test(test_script):
            success = False
    
    if success:
        print("\nAll test suites passed successfully!")
        sys.exit(0)
    else:
        print("\nSome test suites failed!")
        sys.exit(1)

if __name__ == '__main__':
    main()
