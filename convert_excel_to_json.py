import json

# 打开原始文本文件并读取内容
with open('input.txt', 'r', encoding='utf-8') as infile:
    data = infile.read().strip()  # 读取并去除末尾空行

# 分割并处理数据
group = [
    [item for item in line.split('\t')]
    for line in data.split('\n')
]

transposed = list(map(list, zip(*group)))

# 生成数据
data = {
    "members": {
        str(key): transposed[key-1] for key in range(1, 8)
    }
}

# 保存结果
with open("data.json", "w", encoding="utf-8") as f:
    json.dump(data, f, ensure_ascii=False, indent=2)
