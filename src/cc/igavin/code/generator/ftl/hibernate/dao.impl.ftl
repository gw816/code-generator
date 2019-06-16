<#include "../common/common.ftl">
package ${basePackage}.dao.impl;

import java.util.List;
import org.springframework.stereotype.Repository;
import ${basePackage}.model.${tableNamePojoNameMap[tableName]};
import ${basePackage}.dao.${tableNamePojoNameMap[tableName]}Dao;
import cc.igavin.security.support.GenericHibernateDao;
import cc.igavin.security.support.Page;


/**
 * ${tableComment}数据访问实现层
 * @author ${author}
 * @since ${currentTime}
 */
@Repository("${tableNamePojoNameMap[tableName]}Dao")
public class ${tableNamePojoNameMap[tableName]}DaoImpl extends GenericHibernateDao<${tableNamePojoNameMap[tableName]}, String> implements ${tableNamePojoNameMap[tableName]}Dao{
	/**
	* 添加一条${tableComment}记录
	* @param elemType ${tableComment}对象
	* @return int 执行成功的数量
	*/
	@Override
	public int insert(${tableNamePojoNameMap[tableName]} elemType) {
		try{
			this.save(elemType);
		}catch(Exception e){
			System.out.println("保存${tableComment}错误！");
			e.printStackTrace();
			return 0;
		}
		return 1;
	}
	<#if pksMap[tableName]?exists>
	
	/**
	* 根据主键删除一条${tableComment}记录
	* @param key 主键值
	* @return int 执行成功的数量
	*/
	@Override
	public int delete(Object key) {
		try {
			this.deleteByKey(key.toString());
		} catch (Exception e) {
			System.out.println("删除${tableComment}错误！");
			e.printStackTrace();
			return 0;
		}
		return 1;
	}
	
	/**
	* 根据主键查询一条${tableComment}
	* @param key 主键值
	* @return 查询到的${tableComment}对象
	*/
	@Override
	public ${tableNamePojoNameMap[tableName]} query(Object key){
		return get(key.toString());
	}
	
	/**
	*根据主键批量更新${tableComment}
	* @param parameter List<${tableNamePojoNameMap[tableName]}> 对象集
	* @return int[] 每个对象对应执行成功的数量
	*/
	@Override
	public int[] updateBatch(List<${tableNamePojoNameMap[tableName]}> parameter) {
		int[] result=new int[parameter.size()];
		for(int i=0;i<parameter.size();i++){
			try{
				this.update(parameter.get(i));
				result[i]=1;
			}catch(Exception e){
				System.out.println("保存${tableComment}错误！");
				result[i]=0;
			}
		}
		return result;
	}
	
	/**
	*根据主键批量删除${tableComment}
	* @param parameter 主键集
	* @return int[] 每个对象对应执行成功的数量
	*/
	@Override
	public int[] deleteBatch(List<Object> parameter) {
		int[] result=new int[parameter.size()];
		for(int i=0;i<parameter.size();i++){
			try {
				this.deleteByKey(parameter.get(i).toString());
				result[i]=1;
			} catch (Exception e) {
				System.out.println("批量删除${tableComment}错误！");
				e.printStackTrace();
				result[i]=0;
			}
		}
		return result;
	}
	
	/**
	 * 根据PK，和条件，只更新${tableComment}对象指定列的内容
	 * @param pk
	 * @param keys
	 * @param values
	 * @return
	 */
	@Override
	public int updatePart(Object pk, String[] keys, Object... values) {
		StringBuilder sql=new StringBuilder("update ${tableNamePojoNameMap[tableName]} set ");
		for(int i=0;i<keys.length;i++){
			sql.append(keys[i]);
			sql.append("=?");
			if(i<keys.length-1){
				sql.append(" , ");
			}
		}
		sql.append(" where cid=?");
		Object[] values2=new Object[values.length+1];
		for(int i=0;i<values.length;i++){
			values2[i]=values[i];
		}
		values2[values2.length-1]=pk;
		return this.bulkUpdate(sql.toString(), values2);
	}

	</#if>
	
	/**
	*查询所有${tableComment}
	* @return List<${tableNamePojoNameMap[tableName]}> 对象集
	*/
	@Override
	public List<${tableNamePojoNameMap[tableName]}> queryForList() {
		return loadAll();
	}

	/**
	* 根据多个条件查询${tableComment}记录
	* @param keys 键名数组
	* @param values 对应键名数组长度的多个条件值
	* @return ${tableComment}对象集
	*/
	@Override
	public List<${tableNamePojoNameMap[tableName]}> queryForList(String[] keys,Object... values) {
		StringBuilder sql = new StringBuilder("select c from ${tableNamePojoNameMap[tableName]} c where 0=0 ");
		for(String key:keys){
			sql.append(" and c."+key+"=?");
		}
		try {
			return this.find(sql.toString(),values);
		} catch (Exception e) {
			System.out.println("根据多条件查询${tableComment}错误！");
			e.printStackTrace();
			return null;
		}
	}
	
	/**
	* 根据多个条件删除多个${tableComment}
	* @param keys 键名数组
	* @param values 对应键名数组长度的多个条件值
	* @return int 执行成功的数量
	*/
	@Override
	public int delete(String[] keys,Object... values) {
		StringBuilder sql=new StringBuilder("delete from ${tableNamePojoNameMap[tableName]} where ");
		for(int i=0;i<keys.length;i++){
			sql.append(keys[i]);
			sql.append("=?");
			if(i<keys.length-1){
				sql.append(" and ");
			}
		}
		return this.bulkUpdate(sql.toString(), values);
	}
	
	/**
	* 批量添加${tableComment}
	* @param parameter ${tableComment}对象集
	* @return int[] 每个对象添加的成功数量
	*/
	@Override
	public int[] insertBatch(List<${tableNamePojoNameMap[tableName]}> parameter) {
		int[] result=new int[parameter.size()];
		for(int i=0;i<parameter.size();i++){
			try{
				this.save(parameter.get(i));
				result[i]=1;
			}catch(Exception e){
				System.out.println("保存${tableComment}错误！");
				result[i]=0;
			}
		}
		return result;
	}
	
	/**
	* 获取${tableComment}分页数据
	* @param parameter page Page
	* @return 分页结果 Page
	*/
	@Override
	public Page queryPage(Page page){
		String queryPage = "from ${tableNamePojoNameMap[tableName]}";
		String queryCount = "select count(*) from ${tableNamePojoNameMap[tableName]}";
		return this.getPage(queryPage, queryCount, page);
	}
}