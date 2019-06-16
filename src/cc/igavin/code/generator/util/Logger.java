package cc.igavin.code.generator.util;

/**
 * Created by GavinGao on 2019-05-10 17:52.
 * 建议将该日志工具替换成其他框架
 */
public class Logger {
//	private static org.slf4j.Logger logger = LoggerFactory.getLogger(CodeGenerator.class);
	public static final String PRE_SHORT = "------------";
	public static final String PRE_MID = "------------------------";
	public static final String PRE_LONG = "------------------------------------";

	public static void info(String info) {
//		logger.info(info);
		System.out.println("[INFO]" + info);
	}

	public static void warning(String info) {
//		logger.warn(info);
		System.out.println("[WARNING]" + info);
	}
}
