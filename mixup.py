import numpy as np
import matplotlib.pyplot as plt
from PIL import Image
import os
import tkinter as tk
from tkinter import filedialog


# 创建一个Tkinter窗口以打开文件选择对话框
root = tk.Tk()
root.withdraw()  # 隐藏Tkinter窗口

# 使用文件选择对话框选择图像文件
image_path = filedialog.askopenfilename()
image_name = os.path.splitext(os.path.basename(image_path))[0]
image_path1 = filedialog.askopenfilename()
image_name1 = os.path.splitext(os.path.basename(image_path1))[0]
# 要分割的图像文件路径
# image_path = 'C:/Users/root/Desktop/00016.jpg'  # 替换成你的图像文件路径
# image_path1 = 'C:/Users/root/Desktop/00044.jpg'
block_size = 32  # 替换成你想要的块大小


# 打开图像
image = Image.open(image_path)
image1 = Image.open(image_path1)

image1 = image1.resize(image.size)


width, height = image.size

alpha = 2
beta = 2

# 创建一个空白图像，用于拼接块
result_image = Image.new('RGB', (width, height))

# 遍历图像并分割成块
for x in range(0, width, block_size):
    for y in range(0, height, block_size):
        box = (x, y, x + block_size, y + block_size)
        block = image.crop(box)
        block1 = image1.crop(box)
        
        # 生成单个 Beta 分布权重
        weight = np.random.beta(alpha, beta)
        
        # 将权重应用到块上
        block = Image.fromarray((np.array(block) * weight).astype(np.uint8))
        block1 = Image.fromarray((np.array(block1) * (1-weight)).astype(np.uint8))
        block = Image.fromarray(np.array(block).astype(np.uint8) + np.array(block1).astype(np.uint8))

        result_image.paste(block, box)

# 保存最终图像
result_image.save(f'{image_name}_{image_name1}.jpg')  # 替换成你想要的输出文件名