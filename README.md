# code-generator

代码生成器

原理：通过解析数据库结构，然后根据相关信息生成Java代码，有modal\dao\service\controller\mapper等等内容。

核心功能已经完善。

后期重点工作是修改自己需要的模版，修改前先了解一下freemarker语法。
代码中已包含多版本的模版，不同类型的生成模版参差不齐，可以选择生成jpa\mybatis\hibernate\jdbc等风格的代码，前端可以分为ng\seajs等版本，目前维护较为全面的是jpa，基本可用的有mybatis和jdbc，hibernate写的最简陋。

这是个基础版，在本地运行；但入口方法灵活，可以很轻松改造成web方式或者其它方式，因为web端没什么技术含量另外也风格各异，所以那部分不包含在本开源项目中。

目前有mysql和oracle两类生成器实现，如果有其它数据的生成器，需要自己继承Gen实现相关方法即可。

需要Gradle或者Maven的自己配置依赖：

```groovy
compile group: 'org.freemarker', name: 'freemarker', version: '2.3.20'
compile group: 'commons-dbutils', name: 'commons-dbutils', version: '1.6'
compile group: 'ojdbc', name: 'ojdbc', version: '14'
compile 'commons-io:commons-io:2.4'
compile("mysql:mysql-connector-java")
```


