package cc.igavin.code.generator.gen;

/**
 * 启动程序，启动前请检查config.properties文件格式
 * @author Gavin[https://igavin.cc]
 */
public class StartGenerator {
	public static void main(String[] args) throws Exception {
		CodeGenerator freemarkerGen = new CodeGenerator();
		freemarkerGen.init(args);
		freemarkerGen.gen();
		Runtime.getRuntime().exec("open " + freemarkerGen.getOutDir());
	}
}
