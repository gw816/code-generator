<#include "common.ftl">
package ${basePackage}.controller;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import javax.servlet.http.HttpServletResponse;
import cc.igavin.framework.common.SystemMessage;
import cc.igavin.commons.jpa.Paginator;
import cc.igavin.commons.jpa.PaginatorParam;
<#assign tableNamePojoName=tableNamePojoNameMap[tableName] />
<#assign firstSmallTableNamePojoName=tableNamePojoName?uncap_first />
import ${basePackage}.model.${tableNamePojoName};
import ${basePackage}.service.${tableNamePojoName}Service;

/**
 * ${tableComment}控制层
 * @author ${author}
 * @since ${currentTime}
 */
@Controller
@RequestMapping("/${tableNamePojoName}Controller")
public class ${tableNamePojoName}Controller{
	@Autowired
	private ${tableNamePojoName}Service ${firstSmallTableNamePojoName}Service;
	
	<#if pksMap[tableName]?exists>
	/**
	 * 添加一条${tableComment}记录
	 * @param a${tableNamePojoName} 添加的对象
	 * @return SystemMessage
	 * @see ${tableNamePojoName} 其中result属性值为${tableNamePojoName}
	 */
	@RequestMapping(value = "/add${tableNamePojoName}", method = RequestMethod.POST)
	public @ResponseBody SystemMessage add${tableNamePojoName}(@RequestBody ${tableNamePojoName} a${tableNamePojoName}){
		return new SystemMessage("ok","添加成功！",${firstSmallTableNamePojoName}Service.add${tableNamePojoName}(a${tableNamePojoName}));
	}
	
	/**
	 * 删除一条${tableComment}记录
	 * @param id 主键id
	 * @return SystemMessage
	 */
	@RequestMapping(value = "/delete${tableNamePojoName}/{id}", method = RequestMethod.DELETE)
	public @ResponseBody SystemMessage delete${tableNamePojoName}(@PathVariable(value="id") Long id){
		${firstSmallTableNamePojoName}Service.delete${tableNamePojoName}(id);
		return new SystemMessage("ok","删除成功！",id);
	}
	
	/**
	 * 删除多条${tableComment}记录
	 * @param ids 主键id集合
	 * @return SystemMessage
	 */
	@RequestMapping(value = "/deleteBatch${tableNamePojoName}", method = RequestMethod.DELETE)
	public @ResponseBody SystemMessage delete${tableNamePojoName}(@RequestBody List<Long> ids){
		${firstSmallTableNamePojoName}Service.deleteBatch${tableNamePojoName}(ids);
		return new SystemMessage("ok","删除成功！",ids);
	}
	
	/**
	 * 更新一条${tableComment}记录
	 * @param a${tableNamePojoName}
	 * @return SystemMessage
	 * @see ${tableNamePojoName} 其中result属性值为${tableNamePojoName}
	 */
	@RequestMapping(value = "/update${tableNamePojoName}", method = RequestMethod.POST)
	public @ResponseBody SystemMessage update${tableNamePojoName}(@RequestBody ${tableNamePojoName} a${tableNamePojoName}){
		return new SystemMessage("ok","更新成功！",${firstSmallTableNamePojoName}Service.update${tableNamePojoName}(a${tableNamePojoName}));		
	}
	
	/**
	 * 查询一条${tableComment}记录
	 * @param id 主键id
	 * @return SystemMessage
	 * @see ${tableNamePojoName} 其中result属性值为${tableNamePojoName}
	 */
	@RequestMapping(value = "/query${tableNamePojoName}/{id}", method = RequestMethod.GET)
	public @ResponseBody SystemMessage query${tableNamePojoName}(@PathVariable(value="id") Long id){
		return new SystemMessage("ok","查询成功！",${firstSmallTableNamePojoName}Service.query${tableNamePojoName}(id));		
	}
	
	/**
	 * 从Excel文件中提取${tableComment}数据前导入数据库（支持多文件）
	 * @param files
	 * @return SystemMessage
	 * @throws Exception
	 */
	@RequestMapping(value = "/importData", method = RequestMethod.POST)
	public @ResponseBody SystemMessage importData(@RequestParam MultipartFile[] files) throws Exception {  
		return new SystemMessage("ok","导入成功！",${firstSmallTableNamePojoName}Service.importData(files));
	}
	</#if>
	
	/**
	 * 导出${tableComment}数据到excel文件
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping(value = "/exportData", method = RequestMethod.GET)
	public @ResponseBody void exportData(HttpServletResponse response) throws Exception {  
		${firstSmallTableNamePojoName}Service.exportData(response);
	}
	
	/**
	 * 获取所有${tableComment}所有记录
	 * @return SystemMessage
	 * @see ${tableNamePojoName} 其中result属性值为List<${tableNamePojoName}>
	 * @throws Exception
	 */
	@RequestMapping(value = "/get${tableNamePojoName}List", method = RequestMethod.GET)
	public @ResponseBody SystemMessage get${tableNamePojoName}List() throws Exception{		
		return new SystemMessage("ok","查询成功！",${firstSmallTableNamePojoName}Service.query${tableNamePojoName}List());		
	}
	
	/**
	 * 分页获取${tableComment}所有记录
	 * @param param 条件过滤
	 * @return SystemMessage
	 * @see ${tableNamePojoName} 其中result属性值为分页格式的的数据列表
	 * @see cc.igavin.common.jpa.Paginator 分页格式对象
	 * @throws Exception
	 */
	@RequestMapping(value = "/get${tableNamePojoName}ListPage", method = RequestMethod.POST)
	public @ResponseBody SystemMessage get${tableNamePojoName}ListPage(@RequestBody PaginatorParam param) throws Exception{		
		return new SystemMessage("ok","查询成功！",${firstSmallTableNamePojoName}Service.query${tableNamePojoName}ListPage(param));
	}
}