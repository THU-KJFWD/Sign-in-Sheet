import json

def txt_to_json(input_file, output_file):
    with open(input_file, 'r', encoding='utf-8') as infile:
        lines = [line.rstrip('\n') for line in infile if line.rstrip('\n')]  # 仅去除行尾换行符

    columns = {}
    for line in lines:
        items = line.split('\t')
        for col_idx, item in enumerate(items, 1):
            item = item.strip()  # 去除单元格两端的空格（但保留制表符分隔的空列）
            if not item:  # 如果是空字符串，跳过
                continue
            if str(col_idx) not in columns:
                columns[str(col_idx)] = []
            columns[str(col_idx)].append(item)

    result = {"members": columns}

    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(result, f, ensure_ascii=False, indent=2)

# 示例调用
txt_to_json('input.txt', 'data.json')
