package com.yihg.erp.controller.images.utils;
import java.awt.AlphaComposite;
import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.RenderingHints;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
 
import javax.imageio.ImageIO;
import javax.swing.ImageIcon;
public class ImageMarkLogoUtil {
	// 水印透明度 
    private static float alpha = 0.5f;
    // 水印横向位置
    private static int positionWidth = 150;
    // 水印纵向位置
    private static int positionHeight = 300;
    /**
     * 
     * @param alpha 
     *          水印透明度
     * @param positionWidth 
     *          水印横向位置
     * @param positionHeight 
     *          水印纵向位置
     */
    public static void setImageMarkOptions(float alpha , int positionWidth , int positionHeight ,Font font,Color color){
        if(alpha!=0.0f)ImageMarkLogoUtil.alpha = alpha;
        if(positionWidth!=0)ImageMarkLogoUtil.positionWidth = positionWidth;
        if(positionHeight!=0)ImageMarkLogoUtil.positionHeight = positionHeight;
    }
     
    /**
     * 给图片添加水印图片
     * 
     * @param iconPath
     *            水印图片路径
     * @param srcImgPath
     *            源图片路径
     * @param targerPath
     *            目标图片路径
     */
    public static void markImageByIcon(String iconPath, String srcImgPath,
            String targerPath) {
        markImageByIcon(iconPath, srcImgPath, targerPath, null);
    }
 
    /**
     * 给图片添加水印图片、可设置水印图片旋转角度
     * 
     * @param iconPath
     *            水印图片路径
     * @param srcImgPath
     *            源图片路径
     * @param targerPath
     *            目标图片路径
     * @param degree
     *            水印图片旋转角度
     */
    public static void markImageByIcon(String iconPath, String srcImgPath,
            String targerPath, Integer degree) {
        OutputStream os = null;
        try {
             
            Image srcImg = ImageIO.read(new File(srcImgPath));
 
            BufferedImage buffImg = new BufferedImage(srcImg.getWidth(null),
                    srcImg.getHeight(null), BufferedImage.TYPE_INT_RGB);
 
            // 1、得到画笔对象
            Graphics2D g = buffImg.createGraphics();
 
            // 2、设置对线段的锯齿状边缘处理
            g.setRenderingHint(RenderingHints.KEY_INTERPOLATION,RenderingHints.VALUE_INTERPOLATION_BILINEAR);
            g.drawImage(srcImg.getScaledInstance(srcImg.getWidth(null), srcImg.getHeight(null), Image.SCALE_SMOOTH), 0, 0, null);
            // 3、设置水印旋转
            if (null != degree) {
                g.rotate(Math.toRadians(degree),(double) buffImg.getWidth() / 2, (double) buffImg.getHeight() / 2);
            }
 
            // 4、水印图片的路径 水印图片一般为gif或者png的，这样可设置透明度
            ImageIcon imgIcon = new ImageIcon(iconPath);
 
            // 5、得到Image对象。
            Image img = imgIcon.getImage();
             
            g.setComposite(AlphaComposite.getInstance(AlphaComposite.SRC_ATOP,alpha));
 
            // 6、水印图片的位置
            g.drawImage(img, positionWidth, positionHeight, null);
            g.setComposite(AlphaComposite.getInstance(AlphaComposite.SRC_OVER));
            // 7、释放资源
            g.dispose();
             
            // 8、生成图片
            os = new FileOutputStream(targerPath);
            ImageIO.write(buffImg, "JPG", os);
 
            System.out.println("图片完成添加水印图片");
             
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (null != os)
                    os.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
 
   
 
   
     
    public static void main(String [] args){
        String srcImgPath = "C:\\Users\\anpushang\\Desktop\\20150612114343.png";  
       // String logoText = "[ I love Qie]";
        String iconPath = "C:\\Users\\anpushang\\Desktop\\logo.png";  
         
        //String targerTextPath = "C:\\Users\\anpushang\\Desktop\\123.png";  
        //String targerTextPath2 = "C:\\Users\\anpushang\\Desktop\\123.png";
         
        String targerIconPath = "D:\\MOFANG\\23";  
        //String targerIconPath2 = "C:\\Users\\anpushang\\Desktop\\4444422.png";
         
       // System.out.println("给图片添加水印文字开始...");
        // 给图片添加水印文字  
       // markImageByText(logoText, srcImgPath, targerTextPath);  
        // 给图片添加水印文字,水印文字旋转-45  
       // markImageByText(logoText, srcImgPath, targerTextPath2, -45);  
       // System.out.println("给图片添加水印文字结束...");
         
        System.out.println("给图片添加水印图片开始...");
        setImageMarkOptions(0.3f,150,300,null,null);
        // 给图片添加水印图片  
        markImageByIcon(iconPath, srcImgPath, targerIconPath);  
        // 给图片添加水印图片,水印图片旋转-45  
        //markImageByIcon(iconPath, srcImgPath, targerIconPath2, -45); 
        System.out.println("给图片添加水印图片结束...");
    }
}
