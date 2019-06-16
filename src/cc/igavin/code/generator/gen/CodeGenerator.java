package cc.igavin.code.generator.gen;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStreamWriter;
import java.io.UnsupportedEncodingException;
import java.io.Writer;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import cc.igavin.code.generator.util.Logger;
import cc.igavin.code.generator.util.Num;
import cc.igavin.code.generator.impl.GenMySQL;
import cc.igavin.code.generator.impl.GenOracle;
import cc.igavin.code.generator.interfaces.Gen;
import cc.igavin.code.generator.util.GenUtil;
import org.apache.commons.io.FileUtils;

import freemarker.template.Configuration;
import freemarker.template.DefaultObjectWrapper;
import freemarker.template.Template;
import freemarker.template.TemplateException;

/**
 * 利用freemarker生成代码
 * @author Gavin[https://igavin.cc]
 */
public class CodeGenerator {
	private Configuration GenConfig;
	private String ftlDir;

	private InputStream cofigInputStream;
	private String outputDir;
	private String outputPackage;
	private String outputType;
	private String outputTypeFrontEnd;
	private String outFileEncode;
	private String[] tables;

	private Gen gen;
	private Map<String, Object> rootMap = new HashMap<String, Object>();


	/**
	 * 初始化参数
	 * @param args 可不传。args[0]=配置文件路径，args[1]=输出目录
	 * @author: Gavin[https://igavin.cc]
	 */
	public void init(String[] args) {
		String defaultConfig="config.properties";
		if(args == null ||	args.length == 0){
			Logger.info("use default configration[config.properties]...");
		}else{
			defaultConfig=args[0];
			Logger.info("use user configration["+defaultConfig+"]...");
		}
		this.cofigInputStream = ClassLoader.getSystemResourceAsStream(defaultConfig);
		if (this.cofigInputStream == null) {
			try {
				this.cofigInputStream = new FileInputStream(defaultConfig);
			} catch (FileNotFoundException e) {
				e.printStackTrace();
				return;
			}
		}
		// load config
		InputStream inputStream = this.cofigInputStream;
		Properties properties = new Properties();
		try {
			properties.load(inputStream);
		} catch (IOException e) {
			e.printStackTrace();
			return;
		}

		if(args.length == 2) {
			this.outputDir = args[1];
		}

		init(properties);
	}

	/**
	 * 初始化参数
	 * @param properties 参考config.properties
	 * @author: Gavin[https://igavin.cc]
	 */
	public void init(Properties properties) {
		String characterFilter=properties.getProperty("characterFilter");
		if(null != characterFilter&&!characterFilter.trim().equals("")){
			GenUtil.characterFilter=characterFilter.split("\\|");
		}
		this.ftlDir = "/cc/igavin/code/generator/ftl/";
		this.GenConfig = new Configuration();
		this.GenConfig.setClassForTemplateLoading(this.getClass(), ftlDir);
		this.GenConfig.setObjectWrapper(new DefaultObjectWrapper());
		this.outFileEncode = properties.getProperty("outFileEncode");
		this.GenConfig.setDefaultEncoding(outFileEncode);
		
		if(this.outputDir==null){
			this.outputDir = properties.getProperty("output.dir");
		}
		if (!this.outputDir.endsWith(File.separatorChar+"")) {
			this.outputDir += File.separatorChar;
		}
		this.outputPackage = properties.getProperty("output.package");
		this.outputType = properties.getProperty("output.type");
		if(null!=properties.getProperty("output.type.frontEnd")){
			this.outputTypeFrontEnd=properties.getProperty("output.type.frontEnd");
		}else{
			this.outputTypeFrontEnd="ng";
		}
		
		String tables=properties.getProperty("tables");
		if(null!=tables&&!tables.trim().equals("")){
			this.tables=properties.getProperty("tables").split("\\|");
		}

		try {
			this.checkDir();
		} catch (IOException e) {
			e.printStackTrace();
			return;
		}

		String databaseType = properties.getProperty("database.type").toLowerCase();
		Logger.info("databaseType:" + databaseType);
		if (databaseType.equals("mysql")) {
			try {
				this.gen = new GenMySQL(properties);
			} catch (Exception e) {
				e.printStackTrace();
				return;
			}
		} else {
			try {
				this.gen = new GenOracle(properties);
			} catch (Exception e) {
				e.printStackTrace();
				return;
			}
		}
	}

	private void checkDir() throws IOException {
		// check dir
		File dirPojo = new File(this.outputDir);
		if (!dirPojo.exists()) {
			dirPojo.mkdirs();
		} else {
			FileUtils.cleanDirectory(dirPojo);
		}
	}

	private void setFtlParam(String tableName) {
		rootMap.put("tableName", tableName);
		rootMap.put("tableNamePojoNameMap", this.gen.getTableNamePojoNameMap());
		rootMap.put("tableNameCommentsMap", this.gen.getTableNameCommentsMap());
		rootMap.put("pksMap", this.gen.getPksMap());
		rootMap.put("columnNames", this.gen.getColumnNameMap().get(tableName));
		rootMap.put("unPkColumns", this.gen.getUnPkColumns(tableName));
		rootMap.put("columnJavaTypeMap", this.gen.getColumnJavaTypeMap());
		rootMap.put("columnDBTypeMap", this.gen.getColumnDBTypeMap());
		rootMap.put("columnJavaNameMap", this.gen.getColumnJavaNameMap());
		rootMap.put("columnNullableMap", this.gen.getColumnNullableMap());
		rootMap.put("columnCommentsMap", this.gen.getColumnCommentsMap());
		rootMap.put("cnum", Num.getNum());
		if(null == this.gen.getAuthor()){
			rootMap.put("author", "CodeGenerator");
		}else{
			rootMap.put("author", this.gen.getAuthor());
		}
		SimpleDateFormat df = new SimpleDateFormat("yyyy/MM/dd");
		rootMap.put("currentTime", df.format(Calendar.getInstance().getTime()));
		rootMap.put("basePackage", this.outputPackage);
	}

	public void gen(){
		Logger.info(Logger.PRE_LONG);
		
		/*String pureName=ftl.replace(".ftl", "").replace("common/", "").replace(outputType+"/", "");
		String outputpath;
		String suffix;
		if("manager".equals(pureName)){
			suffix=".jsp";
			outputpath=this.outputDir+"web"+File.separator+"manager"+File.separator;
		}else if("module".equals(pureName)){
			suffix=".js";
			outputpath=this.outputDir+"web"+File.separator+"module"+File.separator;
		}else if("form".equals(pureName)){
			suffix=".html";
			outputpath=this.outputDir+"web"+File.separator+"form"+File.separator;
		}else{
			String separator=File.separator;
			if(separator.equals("\\")){
				separator="\\\\";
			}
			outputpath=this.outputDir+"src"+File.separator+pureName.replaceAll("\\.",separator)+File.separator;
			if("mapper".equals(pureName)){
				suffix=".xml";
			}else{
				suffix=".java";
			}
		}
		File f=new File(outputpath);
		if(!f.exists()){
			f.mkdirs();
		}
		if(!"model".equals(pureName)){
			String[] segs = pureName.split("\\.");
			StringBuilder sb = new StringBuilder();
			for (int i = 0; i < segs.length; i++) {
				sb.append(GenUtil.UpperFirstLowerOthers(segs[i]));
			}
			suffix=sb.toString()+suffix;
		}*/
		aGen("controller","common/controller.ftl",
				this.outputDir+"src"+File.separator+"controller"+File.separator,"Controller.java");
		
		aGen("service","common/service.ftl",
				this.outputDir+"src"+File.separator+"service"+File.separator,"Service.java");
		
		aGen("service.impl","common/service.impl.ftl",
				this.outputDir+"src"+File.separator+"service"+File.separator+"impl"+File.separator,"ServiceImpl.java");
		
		
		
		if("jpa".equals(outputType)){
			aGen("model","jpa/model.ftl",
					this.outputDir+"src"+File.separator+"model"+File.separator,".java");
			
			aGen("dao","jpa/dao.ftl",
					this.outputDir+"src"+File.separator+"dao"+File.separator,"Dao.java");
		}else if("jdbc".equals(outputType)){
			aGen("dao","jdbc/dao.ftl",
					this.outputDir+"src"+File.separator+"dao"+File.separator,"Dao.java");
			
			aGen("model","jdbc/model.ftl",
					this.outputDir+"src"+File.separator+"model"+File.separator,".java");
			
			aGen("dao.impl","jdbc/dao.impl.ftl",
					this.outputDir+"src"+File.separator+"dao"+File.separator+"impl"+File.separator,"DaoImpl.java");
		}else if("hibernate".equals(outputType)){
			aGen("dao","hibernate/dao.ftl",
					this.outputDir+"src"+File.separator+"dao"+File.separator,"Dao.java");
			
			aGen("mapper","hibernate/mapper.ftl",
					this.outputDir+"src"+File.separator+"mapper"+File.separator,"Mapper.xml");
			
			aGen("model","hibernate/model.ftl",
					this.outputDir+"src"+File.separator+"model"+File.separator,".java");
			
			aGen("dao.impl","hibernate/dao.impl.ftl",
					this.outputDir+"src"+File.separator+"dao"+File.separator+"impl"+File.separator,"DaoImpl.java");
		}else if("mybatis".equals(outputType)){
			aGen("dao","mybatis/dao.ftl",
					this.outputDir+"src"+File.separator+"dao"+File.separator,"Dao.java");
			
			aGen("mapper","mybatis/mapper.ftl",
					this.outputDir+"src"+File.separator+"mapper"+File.separator,"Mapper.xml");
			
			aGen("model","mybatis/model.ftl",
					this.outputDir+"src"+File.separator+"model"+File.separator,".java");
			
			aGen("dao.impl","mybatis/dao.impl.ftl",
					this.outputDir+"src"+File.separator+"dao"+File.separator+"impl"+File.separator,"DaoImpl.java");
		}
		
		if("ng".equals(outputTypeFrontEnd)){
			aGen("model","ng/model.ftl",
					this.outputDir+"ng"+File.separator+"model"+File.separator,".ts");
		}else if("seajs".equals(outputTypeFrontEnd)){
			aGen("form","seajs/form.ftl",
					this.outputDir+"web"+File.separator+"form"+File.separator,"Form.html");
			
			aGen("manager","seajs/manager.ftl",
					this.outputDir+"web"+File.separator+"manager"+File.separator,"Manager.jsp");
			
			aGen("module","seajs/module.ftl",
					this.outputDir+"web"+File.separator+"module"+File.separator,".js");
		}
		Logger.info("OVER");
	}

	private void aGen(String pureName,String ftl,String outputpath,String suffix){
		Logger.info("proccessing:" + pureName);
		File f=new File(outputpath);
		if(!f.exists()){
			f.mkdirs();
		}
		Template template=null;
		try {
			template = GenConfig.getTemplate(ftl);
		} catch (IOException e) {
			e.printStackTrace();
		}
		if(template!=null)
		for (String tableName : this.gen.getTablesNames()) {
			boolean canGen=true;
			if(this.tables!=null){
				boolean matched=false;
				for(String aTable:this.tables){
					if(aTable.equals(tableName)){
						matched=true;
						break;
					}
				}
				if(!matched){
					canGen=false;
				}
			}
			if(!canGen){
				continue;
			}
			Logger.info("table:" + tableName);
			this.setFtlParam(tableName);
			
			String modelName = this.gen.getTableNamePojoNameMap().get(tableName);
			Writer out=null;
			try {
				out = new OutputStreamWriter(new FileOutputStream(outputpath + modelName + suffix),
						this.outFileEncode);
			} catch (UnsupportedEncodingException | FileNotFoundException e) {
				e.printStackTrace();
			}
			try {
				template.process(rootMap, out);
				out.flush();
			} catch (TemplateException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}finally{
				try {
					if(out!=null)
					out.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	}
	public String getOutDir() {
		return outputDir;
	}

	public String getOutputTypeFrontEnd() {
		return outputTypeFrontEnd;
	}
}
