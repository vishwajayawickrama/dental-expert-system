import dental.App;
import javax.imageio.ImageIO;
import java.io.File;
public class IconBuilder {
  public static void main(String[] args)throws Exception {
    for(int size:new int[]{16,32,128,256,512}) {
      ImageIO.write(App.icon(size),"png",new File(args[0]+"/icon_"+size+"x"+size+".png"));
      ImageIO.write(App.icon(size*2),"png",new File(args[0]+"/icon_"+size+"x"+size+"@2x.png"));
    }
  }
}
