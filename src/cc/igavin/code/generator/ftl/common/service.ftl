<#include "common.ftl">
package ${basePackage}.service;
import java.util.List;
import ${basePackage}.model.${tableNamePojoNameMap[tableName]};
import org.springframework.web.multipart.MultipartFile;
import javax.servlet.http.HttpServletResponse;
import cc.igavin.commons.jpa.Paginator;
import cc.igavin.commons.jpa.PaginatorParam;

/**
 * ${tableComment}服务接口层
 * @author ${author}
 * @since ${currentTime}
 */
public interface ${tableNamePojoNameMap[tableName]}Service{
	<#assign firstBigTableName=tableNamePojoNameMap[tableName]?cap_first />
	/**
	* 添加一条${tableComment}新记录
	* @param a${tableNamePojoNameMap[tableName]} 添加的${tableComment}对象
	*/
	public ${tableNamePojoNameMap[tableName]} add${firstBigTableName}(${tableNamePojoNameMap[tableName]} a${tableNamePojoNameMap[tableName]});
	<#if pksMap[tableName]?exists>
	
	/**
	* 根据主键删除一条${tableComment}记录
	* @param id 主键
	*/
	public void delete${firstBigTableName}(Long id);
	
	/**
	* 根据主键更新一条${tableComment}
	* @param a${tableNamePojoNameMap[tableName]} 要更新的对象
	*/
	public ${tableNamePojoNameMap[tableName]} update${firstBigTableName}(${tableNamePojoNameMap[tableName]} a${tableNamePojoNameMap[tableName]});
	
	/**
	* 根据主键查询一条${tableComment}
	* @param id 主键
	* @return 查询到的${tableComment}对象
	*/
	public ${tableNamePojoNameMap[tableName]} query${firstBigTableName}(Long id);
	
	/**
	*根据主键批量更新${tableComment}
	* @param parameters 对象集
	*/
	public void updateBatch${firstBigTableName}(List<${tableNamePojoNameMap[tableName]}> parameters);
	
	/**
	* 根据主键批量删除${tableComment}
	* @param ids 主键集
	*/
	public void deleteBatch${firstBigTableName}(List<Long> ids);
	/**
	 * 从Excel文件中提取${tableComment}数据并入库（支持多文件）
	 * @param files 上传的excel文件
	 * @return 文件导入成功的个数
	 */
	public int importData(MultipartFile[] files);
	</#if>
	/**
	 * 导出${tableComment}数据到excel文件
	 * @param response
	 */
	public void exportData(HttpServletResponse response);
	/**
	* 查询所有${tableComment}
	* @return ${tableComment}对象集
	*/
	public List<${tableNamePojoNameMap[tableName]}> query${firstBigTableName}List();
	
	/**
	* 批量添加${tableComment}记录
	* @param parameters List<${tableNamePojoNameMap[tableName]}>${tableComment}对象集
	*/
	public void addBatch${firstBigTableName}(List<${tableNamePojoNameMap[tableName]}> parameters);
	
	/**
	* 分页获取${tableComment}记录
	* @param param 条件
	* @return 分页结果
	*/
	public Paginator<${tableNamePojoNameMap[tableName]}> query${tableNamePojoNameMap[tableName]}ListPage(PaginatorParam param);
}