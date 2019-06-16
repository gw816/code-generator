<#include "../common/common.ftl">
package ${basePackage}.dao;
import java.util.List;
import java.util.Map;
import cc.igavin.jdbc.Paginator;
import cc.igavin.jdbc.PaginatorParam;
import ${basePackage}.model.${tableNamePojoNameMap[tableName]};
import org.springframework.dao.DataAccessException;

/**
 * ${tableComment}数据访问接口层
 * @author ${author}
 * @since ${currentTime}
 */
public interface ${tableNamePojoNameMap[tableName]}Dao{
	
	/**
	* 添加一条${tableComment}记录
	* @param elemType ${tableComment}对象
	* @return int 执行成功的数量
	* @throws DataAccessException
	*/
	public int insert(${tableNamePojoNameMap[tableName]} elemType) throws DataAccessException;
	<#if pksMap[tableName]?exists>
	
	/**
	* 根据主键删除一条${tableComment}记录
	* @param PK 主键
	* @return int 执行成功的数量
	* @throws DataAccessException
	*/
	public int delete(Map<String,Object> PK) throws DataAccessException;
	
	/**
	* 根据主键更新${tableComment}
	* @param elemType 要更新的对象
	* @return int 执行成功的数量
	* @throws DataAccessException
	*/
	public int update(${tableNamePojoNameMap[tableName]} elemType) throws DataAccessException;
	
	/**
	* 根据主键查询${tableComment}
	* @param PK 主键
	* @return 查询到的${tableComment}对象
	* @throws DataAccessException
	*/
	public ${tableNamePojoNameMap[tableName]} query(Map<String,Object> PK) throws DataAccessException;
	
	/**
	* 根据主键批量更新${tableComment}记录
	* @param parameter ${tableComment}对象集
	* @return int[] 每个对象对应执行成功的数量
	* @throws DataAccessException
	*/
	public int[] updateBatch(List<${tableNamePojoNameMap[tableName]}> parameter) throws DataAccessException;
	
	/**
	* 根据主键批量删除${tableComment}记录
	* @param PKs 主键集
	* @return int[] 每个对象对应执行成功的数量
	* @throws DataAccessException
	*/
	public int[] deleteBatch(List<Map<String,Object>> PKs) throws DataAccessException;

	/**
	 * 更新${tableComment}部分内容
	 * 根据PK，和条件，只更新指定列的内容
	 * keys和values的长度必须一致，keys对应数据库表的字段名而不是属性名
	 * @param PK 主键
	 * @param keys 要修改的数据库字段名
	 * @param values 要修改的数据库字段值
	 * @return 更新成功的数量
	 * @throws DataAccessException
	 */
	public int updatePart(Map<String,Object> PK,String[] keys,Object...values) throws DataAccessException;

	</#if>

	/**
	* 查询所有${tableComment}记录
	* @return ${tableComment}对象集
	* @throws DataAccessException
	*/
	public List<${tableNamePojoNameMap[tableName]}> queryForList() throws DataAccessException;
	
	/**
	* 根据多个条件查询所有${tableComment}记录
	* @param keys 键名数组
	* @param values 对应键名数组长度的多个条件值
	* @return ${tableComment}对象集
	* @throws DataAccessException
	*/
	public List<${tableNamePojoNameMap[tableName]}> queryForList(String[] keys,Object... values) throws DataAccessException;
	
	/**
	* 根据多个条件删除多个${tableComment}记录
	* @param keys 键名数组
	* @param values 对应键名数组长度的多个条件值
	* @return int 执行成功的数量
	* @throws DataAccessException
	*/
	public int delete(String[] keys,Object... values) throws DataAccessException;
	
	/**
	* 批量添加${tableComment}记录
	* @param parameter ${tableComment}对象集
	* @return int[] 每个对象添加的成功数量
	* @throws DataAccessException
	*/
	public int[] insertBatch(List<${tableNamePojoNameMap[tableName]}> parameter) throws DataAccessException;
	
	
	/**
	* 分页获取${tableComment}记录
	* @param param 条件
	* @return 分页结果
	* @throws DataAccessException
	*/
	public Paginator<${tableNamePojoNameMap[tableName]}> queryForListPage(PaginatorParam<${tableNamePojoNameMap[tableName]}> param) throws DataAccessException;
}