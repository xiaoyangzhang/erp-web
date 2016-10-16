package com.yihg.erp.controller.images.utils;

import java.awt.Color;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

import javax.imageio.ImageIO;


public class imageMark {
	
	/**
	 * 演示代码
	 * 
	 * @param args
	 */
	public static void main(String[] args) {
		Translucent(new File("C:\\Users\\anpushang\\Desktop\\20150612114343.png"), new File("C:\\Users\\anpushang\\Desktop\\2we.png"), 100);
		// 将tset.jpg 图片的透明度调整到100 然后保存到 save.jpg 文件
	}

	/**
	 * 半透明一张图片
	 * 
	 * @param image
	 *            需要半透明的图片所在文件
	 * @param save
	 *            保存到的文件
	 * @param alpha
	 *            透明度(0~255)
	 * @return 是否操作成功
	 */
	public static boolean Translucent(File image, File save, int alpha) {
		BufferedImage imageOpen = null, imageSave = null;// 原始图像，保存图像
		int width, height, rgb;// 图片的宽度,高度，临时存放像素点的颜色值
		Color color;// 用于计算颜色值的Color对象
		try {
			imageOpen = ImageIO.read(image);// 打开图像
		} catch (IOException e) {
			e.printStackTrace();
			return false;
		}
		width = imageOpen.getWidth();// 获得图像宽度
		height = imageOpen.getHeight();// 获得图像高度
		imageSave = new BufferedImage(width, height,
				BufferedImage.TYPE_INT_ARGB);
		// 新建一个空白的图像
		for (int x = 0; x < width; x++) {
			for (int y = 0; y < height; y++) {
				rgb = imageOpen.getRGB(x, y);// 获得颜色值
				color = new Color(rgb);// 构建一个Color对象
				color = new Color(color.getRed(), color.getGreen(),
						color.getBlue(), alpha);
				// 重新构建一次Color对象(有透明值的)
				imageSave.setRGB(x, y, color.getRGB());
				// 设置颜色值
			}
		}
		try {
			ImageIO.write(imageSave, "PNG", save);// 保存图像
		} catch (IOException e) {
			e.printStackTrace();
			return false;
		}
		return true;
	}
}
