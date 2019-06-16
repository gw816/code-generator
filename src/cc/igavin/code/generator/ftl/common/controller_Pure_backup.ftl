<#include "common.ftl">
package ${ftls[5][1]};

import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import javax.servlet.http.HttpServletResponse;
import cc.igavin.jdbc.Paginator;
<#assign tableNamePojoName=tableNamePojoNameMap[tableName] />
<#assign firstSmallTableNamePojoName=tableNamePojoName?uncap_first />
import ${ftls[0][1]}.${tableNamePojoName};
import ${ftls[3][1]}.${tableNamePojoName}Service;

/**
 * ${tableComment}控制层
 * @author ${author}
 * @since ${currentTime}
 */
@Controller
@RequestMapping("/${tableNamePojoName}Action")
public class ${tableNamePojoName}Action{
	@Autowired
	private ${tableNamePojoName}Service ${firstSmallTableNamePojoName}Service;
	
	<#if pksMap[tableName]?exists>
	/**
	 * 添加一条${tableComment}记录
	 * @param a${tableNamePojoName} 添加的对象
	 * @return
	 */
	@RequestMapping(value = "/add${tableNamePojoName}", method = RequestMethod.POST)
	public @ResponseBody int add${tableNamePojoName}(@RequestBody ${tableNamePojoName} a${tableNamePojoName}){
		return ${firstSmallTableNamePojoName}Service.add${tableNamePojoName}(a${tableNamePojoName});
	}
	
	/**
	 * 删除一条${tableComment}记录
	 * @param PK Map<String,Object> 主键
	 * @return
	 */
	@RequestMapping(value = "/delete${tableNamePojoName}", method = RequestMethod.POST)
	public @ResponseBody int delete${tableNamePojoName}(@RequestBody Map<String,Object> PK){
		return ${firstSmallTableNamePojoName}Service.delete${tableNamePojoName}(PK);
	}
	
	/**
	 * 删除多条${tableComment}记录
	 * @param PKs List<Map<String,Object>>主键集
	 * @return
	 */
	@RequestMapping(value = "/deleteBatch${tableNamePojoName}", method = RequestMethod.POST)
	public @ResponseBody int delete${tableNamePojoName}(@RequestBody List<Map<String,Object>> PKs){
		return ${firstSmallTableNamePojoName}Service.deleteBatch${tableNamePojoName}(PKs).length;
	}
	
	/**
	 * 更新一条${tableComment}记录
	 * @param a${tableNamePojoName}
	 * @return
	 */
	@RequestMapping(value = "/update${tableNamePojoName}", method = RequestMethod.POST)
	public @ResponseBody int update${tableNamePojoName}(@RequestBody ${tableNamePojoName} a${tableNamePojoName}){
		return ${firstSmallTableNamePojoName}Service.update${tableNamePojoName}(a${tableNamePojoName});		
	}
	
	/**
	 * 查询一条${tableComment}记录
	 * @param PK Map<String,Object> 主键
	 * @return
	 */
	@RequestMapping(value = "/query${tableNamePojoName}", method = RequestMethod.POST)
	public @ResponseBody ${tableNamePojoNameMap[tableName]} query${tableNamePojoName}(@RequestBody Map<String,Object> PK){
		return ${firstSmallTableNamePojoName}Service.query${tableNamePojoName}(PK);		
	}
	
	/**
	 * 从Excel文件中提取${tableComment}数据前导入数据库（支持多文件）
	 * @param files
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/importData")
	public @ResponseBody int importData(@RequestParam MultipartFile[] files) throws Exception {  
		return ${firstSmallTableNamePojoName}Service.importData(files);
	}
	</#if>
	
	/**
	 * 导出${tableComment}数据到excel文件
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping(value = "/exportData")
	public @ResponseBody void exportData(HttpServletResponse response) throws Exception {  
		${firstSmallTableNamePojoName}Service.exportData(response);
	}
	
	/**
	 * 获取所有${tableComment}所有记录
	 * @return List<${tableNamePojoName}>
	 * @throws Exception
	 */
	@RequestMapping(value = "/get${tableNamePojoName}List", method = RequestMethod.POST)
	public @ResponseBody List<${tableNamePojoName}> get${tableNamePojoName}List() throws Exception{		
		return ${firstSmallTableNamePojoName}Service.query${tableNamePojoName}List();		
	}
	
	/**
	 * 按条件获取所有${tableComment}所有记录
	 * @param map 条件信息。比如要查cUnit为essence的所有数据，那{cUnit:essence}
	 * @return List<${tableNamePojoName}>
	 * @throws Exception
	 */
	@RequestMapping(value = "/get${tableNamePojoName}ListByCondition", method = RequestMethod.POST)
	public @ResponseBody List<${tableNamePojoName}> get${tableNamePojoName}ListByCondition(@RequestBody Map<String,Object> map) throws Exception{		
		String[] keys=new String[map.size()];
		keys=map.keySet().toArray(keys);
		Object[] values=map.values().toArray();
		return ${firstSmallTableNamePojoName}Service.query${tableNamePojoName}List(keys,values);	
	}
	
	/**
	 * 分页获取${tableComment}所有记录
	 * @param map {pageSize=10, currentPage=1}
	 * @return List<${tableNamePojoName}>
	 * @throws Exception
	 */
	@RequestMapping(value = "/get${tableNamePojoName}ListPage", method = RequestMethod.POST)
	public @ResponseBody Paginator<${tableNamePojoName}> get${tableNamePojoName}ListPage(@RequestBody Map<String,Object> map) throws Exception{		
		return ${firstSmallTableNamePojoName}Service.query${tableNamePojoName}ListPage(Integer.parseInt(map.get("currentPage").toString()),
				Integer.parseInt(map.get("pageSize").toString()));
	}
}