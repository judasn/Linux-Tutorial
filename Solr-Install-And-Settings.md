## Solr 安装和配置



## Solr 安装

- 官网：<https://lucene.apache.org/solr/>
- 此时（20160329） Solr 最新稳定版本为：**5.5.0**
- 官网下载：<http://www.apache.org/dyn/closer.lua/lucene/solr/5.5.0>
- 官网新手入门：<https://lucene.apache.org/solr/quickstart.html>
- 我个人习惯 `/opt` 目录下创建一个目录 `setups` 用来存放各种软件安装包；在 `/usr` 目录下创建一个 `program` 用来存放各种解压后的软件包，下面的讲解也都是基于此习惯
- 我个人已经使用了第三方源：`EPEL、RepoForge`，如果你出现 `yum install XXXXX` 安装不成功的话，很有可能就是你没有相关源，请查看我对源设置的文章
- 必须先装有 JDK，我这里安装的是 JDK 7
- 先开放防火墙端口：
    - 添加规则：`sudo iptables -A INPUT -p tcp -m tcp --dport 8983 -j ACCEPT`
    - 保存规则：`sudo service iptables save`
    - 重启 iptables：`sudo service iptables restart`
- 我这里使用 solr-4.10.2.zip：（大小：148 M）
    - 解压：`unzip solr-4.10.2.zip`
    - 移动到我个人安装目录：`mv solr-4.10.2/ /usr/program/`
    - 进入解压后目录：`cd /usr/program/solr-4.10.2/example/`
    - 启动 Solr 自带测试案例：`java -jar start.jar`
    - 打开浏览器，访问：`http://192.168.1.115:8983/solr/`，可以看到 Solr 相关页面就表示成功了
    - 给 Solr 这个默认测试案例添加数据：`cd /usr/program/solr-4.10.2/example/exampledocs ; java -jar post.jar solr.xml monitor.xml`
    - 此时，你在 Solr 的默认测试 Core 为 collection1 的 query 下查询就可以看到一些数据。


## Solr 新建 Core

- 进入目录：`cd /usr/program/solr-4.10.2/example`
- 创建项目目录：`mkdir ssm-solr`
- 复制配置文件：`cp /usr/program/solr-4.10.2/example/solr/solr.xml /usr/program/solr-4.10.2/example/ssm-solr`
- 创建一个 Core 目录及两个配置和数据目录：`mkdir -p /usr/program/solr-4.10.2/example/ssm-solr/user/conf /usr/program/solr-4.10.2/example/ssm-solr/user/data`
- 复制配置文件：`cp /usr/program/solr-4.10.2/example/solr/collection1/core.properties /usr/program/solr-4.10.2/example/ssm-solr/user/`
- 编辑配置文件：`vim /usr/program/solr-4.10.2/example/ssm-solr/user/core.properties`
    - 把：`name=collection1`，改为：`name=user`。这个名字就是你的新 Core 的命名，因为我测试的跟会员有关系，所以这里命名为 user
- 配置 IK 分词器
    - IKAnalyzer-2012-4x.jar 放在 /usr/program/solr-4.10.2/example/solr-webapp/webapp/WEB-INF/lib 目录下
- 复制配置文件：`cp /usr/program/solr-4.10.2/example/solr/collection1/conf/schema.xml /usr/program/solr-4.10.2/example/ssm-solr/user/conf/` 
- 复制配置文件：`cp /usr/program/solr-4.10.2/example/solr/collection1/conf/solrconfig.xml /usr/program/solr-4.10.2/example/ssm-solr/user/conf/`
- 编辑配置文件：`vim /usr/program/solr-4.10.2/example/ssm-solr/user/conf/schema.xml`，内容改为如下：

``` xml
<?xml version="1.0" encoding="UTF-8" ?>

<schema name="example" version="1.5">
    
    <field name="_version_" type="long" indexed="true" stored="true"/>
    <field name="_root_" type="string" indexed="true" stored="false"/>
    
    
    <field name="sysUserId" type="long" indexed="true" stored="true" required="true" multiValued="false" /> 
    <field name="sysUserLoginName" type="text_ik" indexed="true" stored="true"/>
    <field name="sysUserRealName" type="text_ik" indexed="true" stored="true"/>
    <field name="sysUserEmail" type="string" indexed="true" stored="true"/>
    <field name="sysUserMobile" type="string" indexed="true" stored="true"/>
    <field name="sysUserRegisterDatetime" type="long" indexed="true" stored="true"/>
    
    
    <uniqueKey>sysUserId</uniqueKey>
    
    
    
    <!--IK分词器-->
    <!--把 indexed="true" 适合做搜索的，并且需要分词的，type改为text_ik-->
    <fieldType name="text_ik" class="solr.TextField">
        <analyzer class="org.wltea.analyzer.lucene.IKAnalyzer"/>
    </fieldType>
    
    <!-- solrQueryParser 可以指定搜索时多个词之间的关系，可以是 (AND|OR) 两种，默认是 OR，表示或的关系。-->
    <!-- 假设在 OR 的情况，我们搜索：小米 手机。则只要含有：小米 或者是：手机的内容都会出现，比如出现：小米手环-->
    <!-- 假设在 OR 的情况，我们搜索：小米 手机。则必须含有：小米 和 手机，两个关键字的内容-->
    <solrQueryParser defaultOperator="AND"/>

    
    <fieldType name="string" class="solr.StrField" sortMissingLast="true" />
    <fieldType name="long" class="solr.TrieLongField" precisionStep="0" positionIncrementGap="0"/>
    <!--<fieldType name="boolean" class="solr.BoolField" sortMissingLast="true"/>-->
    <!--<fieldType name="int" class="solr.TrieIntField" precisionStep="0" positionIncrementGap="0"/>-->
    <!--<fieldType name="float" class="solr.TrieFloatField" precisionStep="0" positionIncrementGap="0"/>-->
    <!--<fieldType name="double" class="solr.TrieDoubleField" precisionStep="0" positionIncrementGap="0"/>-->
    <!--<fieldType name="date" class="solr.TrieDateField" precisionStep="0" positionIncrementGap="0"/>-->

</schema>
```


- 编辑配置文件：`vim /usr/program/solr-4.10.2/example/ssm-solr/user/conf/solrconfig.xml`，内容改为如下：
    - 需要修改的内容有：
        - 将所有的 `<lib>` 标签注释掉，如我中文注释内容
        - 把所有的 `<str name="df">text</str>` 替换成 `<str name="df">sysUserLoginName</str>`，这个 sysUserLoginName 是我在 schema.xm 定义的其中一个字段名字。df 是代表默认 field。
        - 注释掉：`<searchComponent name="elevator" class="solr.QueryElevationComponent">` 的内容

``` xml
<?xml version="1.0" encoding="UTF-8" ?>
<config>
    <luceneMatchVersion>4.10.2</luceneMatchVersion>
    <!--
      注释掉这一段
      <lib dir="../../../contrib/extraction/lib" regex=".*\.jar" />
      <lib dir="../../../dist/" regex="solr-cell-\d.*\.jar" />
      <lib dir="../../../contrib/clustering/lib/" regex=".*\.jar" />
      <lib dir="../../../dist/" regex="solr-clustering-\d.*\.jar" />
      <lib dir="../../../contrib/langid/lib/" regex=".*\.jar" />
      <lib dir="../../../dist/" regex="solr-langid-\d.*\.jar" />
      <lib dir="../../../contrib/velocity/lib" regex=".*\.jar" />
      <lib dir="../../../dist/" regex="solr-velocity-\d.*\.jar" />
    -->

    <dataDir>${solr.data.dir:}</dataDir>
    <directoryFactory name="DirectoryFactory"
                      class="${solr.directoryFactory:solr.NRTCachingDirectoryFactory}">
        <str name="solr.hdfs.home">${solr.hdfs.home:}</str>
        <str name="solr.hdfs.confdir">${solr.hdfs.confdir:}</str>
        <str name="solr.hdfs.blockcache.enabled">${solr.hdfs.blockcache.enabled:true}</str>
        <str name="solr.hdfs.blockcache.global">${solr.hdfs.blockcache.global:true}</str>
    </directoryFactory>
    <codecFactory class="solr.SchemaCodecFactory"/>
    <schemaFactory class="ClassicIndexSchemaFactory"/>
    <indexConfig>
        <lockType>${solr.lock.type:native}</lockType>
        <infoStream>true</infoStream>
        <checkIntegrityAtMerge>false</checkIntegrityAtMerge>
    </indexConfig>
    <jmx/>
    <updateHandler class="solr.DirectUpdateHandler2">
        <updateLog>
            <str name="dir">${solr.ulog.dir:}</str>
        </updateLog>
        <autoCommit>
            <maxTime>${solr.autoCommit.maxTime:15000}</maxTime>
            <openSearcher>false</openSearcher>
        </autoCommit>
        <autoSoftCommit>
            <maxTime>${solr.autoSoftCommit.maxTime:-1}</maxTime>
        </autoSoftCommit>
    </updateHandler>
    <query>
        <maxBooleanClauses>1024</maxBooleanClauses>
        <filterCache class="solr.FastLRUCache"
                     size="512"
                     initialSize="512"
                     autowarmCount="0"/>
        <queryResultCache class="solr.LRUCache"
                          size="512"
                          initialSize="512"
                          autowarmCount="0"/>
        <documentCache class="solr.LRUCache"
                       size="512"
                       initialSize="512"
                       autowarmCount="0"/>
        <cache name="perSegFilter"
               class="solr.search.LRUCache"
               size="10"
               initialSize="0"
               autowarmCount="10"
               regenerator="solr.NoOpRegenerator"/>
        <enableLazyFieldLoading>true</enableLazyFieldLoading>
        <queryResultWindowSize>20</queryResultWindowSize>
        <queryResultMaxDocsCached>200</queryResultMaxDocsCached>
        <listener event="newSearcher" class="solr.QuerySenderListener">
            <arr name="queries">
            </arr>
        </listener>
        <listener event="firstSearcher" class="solr.QuerySenderListener">
            <arr name="queries">
                <lst>
                    <str name="q">static firstSearcher warming in solrconfig.xml</str>
                </lst>
            </arr>
        </listener>
        <useColdSearcher>false</useColdSearcher>
        <maxWarmingSearchers>2</maxWarmingSearchers>
    </query>
    <requestDispatcher handleSelect="false">
        <requestParsers enableRemoteStreaming="true"
                        multipartUploadLimitInKB="2048000"
                        formdataUploadLimitInKB="2048"
                        addHttpRequestToContext="false"/>
        <httpCaching never304="true"/>
    </requestDispatcher>
    <requestHandler name="/select" class="solr.SearchHandler">
        <lst name="defaults">
            <str name="echoParams">explicit</str>
            <int name="rows">10</int>
            <str name="df">sysUserLoginName</str>
        </lst>
    </requestHandler>
    <requestHandler name="/query" class="solr.SearchHandler">
        <lst name="defaults">
            <str name="echoParams">explicit</str>
            <str name="wt">json</str>
            <str name="indent">true</str>
            <str name="df">sysUserLoginName</str>
        </lst>
    </requestHandler>
    <requestHandler name="/get" class="solr.RealTimeGetHandler">
        <lst name="defaults">
            <str name="omitHeader">true</str>
            <str name="wt">json</str>
            <str name="indent">true</str>
        </lst>
    </requestHandler>
    <requestHandler name="/export" class="solr.SearchHandler">
        <lst name="invariants">
            <str name="rq">{!xport}</str>
            <str name="wt">xsort</str>
            <str name="distrib">false</str>
        </lst>
        <arr name="components">
            <str>query</str>
        </arr>
    </requestHandler>
    <requestHandler name="/browse" class="solr.SearchHandler">
        <lst name="defaults">
            <str name="echoParams">explicit</str>
            <str name="wt">velocity</str>
            <str name="v.template">browse</str>
            <str name="v.layout">layout</str>
            <str name="title">Solritas</str>
            <str name="defType">edismax</str>
            <str name="qf">
                text^0.5 features^1.0 name^1.2 sku^1.5 id^10.0 manu^1.1 cat^1.4
                title^10.0 description^5.0 keywords^5.0 author^2.0 resourcename^1.0
            </str>
            <str name="df">sysUserLoginName</str>
            <str name="mm">100%</str>
            <str name="q.alt">*:*</str>
            <str name="rows">10</str>
            <str name="fl">*,score</str>
            <str name="mlt.qf">
                text^0.5 features^1.0 name^1.2 sku^1.5 id^10.0 manu^1.1 cat^1.4
                title^10.0 description^5.0 keywords^5.0 author^2.0 resourcename^1.0
            </str>
            <str name="mlt.fl">text,features,name,sku,id,manu,cat,title,description,keywords,author,resourcename</str>
            <int name="mlt.count">3</int>
            <str name="facet">on</str>
            <str name="facet.missing">true</str>
            <str name="facet.field">cat</str>
            <str name="facet.field">manu_exact</str>
            <str name="facet.field">content_type</str>
            <str name="facet.field">author_s</str>
            <str name="facet.query">ipod</str>
            <str name="facet.query">GB</str>
            <str name="facet.mincount">1</str>
            <str name="facet.pivot">cat,inStock</str>
            <str name="facet.range.other">after</str>
            <str name="facet.range">price</str>
            <int name="f.price.facet.range.start">0</int>
            <int name="f.price.facet.range.end">600</int>
            <int name="f.price.facet.range.gap">50</int>
            <str name="facet.range">popularity</str>
            <int name="f.popularity.facet.range.start">0</int>
            <int name="f.popularity.facet.range.end">10</int>
            <int name="f.popularity.facet.range.gap">3</int>
            <str name="facet.range">manufacturedate_dt</str>
            <str name="f.manufacturedate_dt.facet.range.start">NOW/YEAR-10YEARS</str>
            <str name="f.manufacturedate_dt.facet.range.end">NOW</str>
            <str name="f.manufacturedate_dt.facet.range.gap">+1YEAR</str>
            <str name="f.manufacturedate_dt.facet.range.other">before</str>
            <str name="f.manufacturedate_dt.facet.range.other">after</str>
            <str name="hl">on</str>
            <str name="hl.fl">content features title name</str>
            <str name="hl.preserveMulti">true</str>
            <str name="hl.encoder">html</str>
            <str name="hl.simple.pre">&lt;b&gt;</str>
            <str name="hl.simple.post">&lt;/b&gt;</str>
            <str name="f.title.hl.fragsize">0</str>
            <str name="f.title.hl.alternateField">title</str>
            <str name="f.name.hl.fragsize">0</str>
            <str name="f.name.hl.alternateField">name</str>
            <str name="f.content.hl.snippets">3</str>
            <str name="f.content.hl.fragsize">200</str>
            <str name="f.content.hl.alternateField">content</str>
            <str name="f.content.hl.maxAlternateFieldLength">750</str>
            <str name="spellcheck">on</str>
            <str name="spellcheck.extendedResults">false</str>
            <str name="spellcheck.count">5</str>
            <str name="spellcheck.alternativeTermCount">2</str>
            <str name="spellcheck.maxResultsForSuggest">5</str>
            <str name="spellcheck.collate">true</str>
            <str name="spellcheck.collateExtendedResults">true</str>
            <str name="spellcheck.maxCollationTries">5</str>
            <str name="spellcheck.maxCollations">3</str>
        </lst>
        <arr name="last-components">
            <str>spellcheck</str>
        </arr>
    </requestHandler>
    <requestHandler name="/update" class="solr.UpdateRequestHandler">
    </requestHandler>
    <requestHandler name="/update/extract"
                    startup="lazy"
                    class="solr.extraction.ExtractingRequestHandler">
        <lst name="defaults">
            <str name="lowernames">true</str>
            <str name="uprefix">ignored_</str>
            <str name="captureAttr">true</str>
            <str name="fmap.a">links</str>
            <str name="fmap.div">ignored_</str>
        </lst>
    </requestHandler>
    <requestHandler name="/analysis/field"
                    startup="lazy"
                    class="solr.FieldAnalysisRequestHandler"/>
    <requestHandler name="/analysis/document"
                    class="solr.DocumentAnalysisRequestHandler"
                    startup="lazy"/>
    <requestHandler name="/admin/"
                    class="solr.admin.AdminHandlers"/>
    <requestHandler name="/admin/ping" class="solr.PingRequestHandler">
        <lst name="invariants">
            <str name="q">solrpingquery</str>
        </lst>
        <lst name="defaults">
            <str name="echoParams">all</str>
        </lst>
    </requestHandler>
    <requestHandler name="/debug/dump" class="solr.DumpRequestHandler">
        <lst name="defaults">
            <str name="echoParams">explicit</str>
            <str name="echoHandler">true</str>
        </lst>
    </requestHandler>
    <requestHandler name="/replication" class="solr.ReplicationHandler">
    </requestHandler>
    <searchComponent name="spellcheck" class="solr.SpellCheckComponent">
        <str name="queryAnalyzerFieldType">text_general</str>
        <lst name="spellchecker">
            <str name="name">default</str>
            <str name="field">text</str>
            <str name="classname">solr.DirectSolrSpellChecker</str>
            <str name="distanceMeasure">internal</str>
            <float name="accuracy">0.5</float>
            <int name="maxEdits">2</int>
            <int name="minPrefix">1</int>
            <int name="maxInspections">5</int>
            <int name="minQueryLength">4</int>
            <float name="maxQueryFrequency">0.01</float>
        </lst>
        <lst name="spellchecker">
            <str name="name">wordbreak</str>
            <str name="classname">solr.WordBreakSolrSpellChecker</str>
            <str name="field">name</str>
            <str name="combineWords">true</str>
            <str name="breakWords">true</str>
            <int name="maxChanges">10</int>
        </lst>
    </searchComponent>
    <requestHandler name="/spell" class="solr.SearchHandler" startup="lazy">
        <lst name="defaults">
            <str name="df">sysUserLoginName</str>
            <str name="spellcheck.dictionary">default</str>
            <str name="spellcheck.dictionary">wordbreak</str>
            <str name="spellcheck">on</str>
            <str name="spellcheck.extendedResults">true</str>
            <str name="spellcheck.count">10</str>
            <str name="spellcheck.alternativeTermCount">5</str>
            <str name="spellcheck.maxResultsForSuggest">5</str>
            <str name="spellcheck.collate">true</str>
            <str name="spellcheck.collateExtendedResults">true</str>
            <str name="spellcheck.maxCollationTries">10</str>
            <str name="spellcheck.maxCollations">5</str>
        </lst>
        <arr name="last-components">
            <str>spellcheck</str>
        </arr>
    </requestHandler>
    <searchComponent name="suggest" class="solr.SuggestComponent">
        <lst name="suggester">
            <str name="name">mySuggester</str>
            <str name="lookupImpl">FuzzyLookupFactory</str>
            <str name="dictionaryImpl">DocumentDictionaryFactory</str>
            <str name="field">cat</str>
            <str name="weightField">price</str>
            <str name="suggestAnalyzerFieldType">string</str>
        </lst>
    </searchComponent>
    <requestHandler name="/suggest" class="solr.SearchHandler" startup="lazy">
        <lst name="defaults">
            <str name="suggest">true</str>
            <str name="suggest.count">10</str>
        </lst>
        <arr name="components">
            <str>suggest</str>
        </arr>
    </requestHandler>
    <searchComponent name="tvComponent" class="solr.TermVectorComponent"/>
    <requestHandler name="/tvrh" class="solr.SearchHandler" startup="lazy">
        <lst name="defaults">
            <str name="df">sysUserLoginName</str>
            <bool name="tv">true</bool>
        </lst>
        <arr name="last-components">
            <str>tvComponent</str>
        </arr>
    </requestHandler>
    <searchComponent name="clustering"
                     enable="${solr.clustering.enabled:false}"
                     class="solr.clustering.ClusteringComponent">
        <lst name="engine">
            <str name="name">lingo</str>
            <str name="carrot.algorithm">org.carrot2.clustering.lingo.LingoClusteringAlgorithm</str>
            <str name="carrot.resourcesDir">clustering/carrot2</str>
        </lst>
        <lst name="engine">
            <str name="name">stc</str>
            <str name="carrot.algorithm">org.carrot2.clustering.stc.STCClusteringAlgorithm</str>
        </lst>
        <lst name="engine">
            <str name="name">kmeans</str>
            <str name="carrot.algorithm">org.carrot2.clustering.kmeans.BisectingKMeansClusteringAlgorithm</str>
        </lst>
    </searchComponent>
    <requestHandler name="/clustering"
                    startup="lazy"
                    enable="${solr.clustering.enabled:false}"
                    class="solr.SearchHandler">
        <lst name="defaults">
            <bool name="clustering">true</bool>
            <bool name="clustering.results">true</bool>
            <str name="carrot.title">name</str>
            <str name="carrot.url">id</str>
            <str name="carrot.snippet">features</str>
            <bool name="carrot.produceSummary">true</bool>
            <bool name="carrot.outputSubClusters">false</bool>
            <str name="defType">edismax</str>
            <str name="qf">
                text^0.5 features^1.0 name^1.2 sku^1.5 id^10.0 manu^1.1 cat^1.4
            </str>
            <str name="q.alt">*:*</str>
            <str name="rows">10</str>
            <str name="fl">*,score</str>
        </lst>
        <arr name="last-components">
            <str>clustering</str>
        </arr>
    </requestHandler>
    <searchComponent name="terms" class="solr.TermsComponent"/>
    <requestHandler name="/terms" class="solr.SearchHandler" startup="lazy">
        <lst name="defaults">
            <bool name="terms">true</bool>
            <bool name="distrib">false</bool>
        </lst>
        <arr name="components">
            <str>terms</str>
        </arr>
    </requestHandler>

    <!--  
      <searchComponent name="elevator" class="solr.QueryElevationComponent" >
        <str name="queryFieldType">string</str>
        <str name="config-file">elevate.xml</str>
      </searchComponent>
      -->
    <requestHandler name="/elevate" class="solr.SearchHandler" startup="lazy">
        <lst name="defaults">
            <str name="echoParams">explicit</str>
            <str name="df">sysUserLoginName</str>
        </lst>
        <arr name="last-components">
            <str>elevator</str>
        </arr>
    </requestHandler>
    <searchComponent class="solr.HighlightComponent" name="highlight">
        <highlighting>
            <fragmenter name="gap"
                        default="true"
                        class="solr.highlight.GapFragmenter">
                <lst name="defaults">
                    <int name="hl.fragsize">100</int>
                </lst>
            </fragmenter>
            <fragmenter name="regex"
                        class="solr.highlight.RegexFragmenter">
                <lst name="defaults">
                    <int name="hl.fragsize">70</int>
                    <float name="hl.regex.slop">0.5</float>
                    <str name="hl.regex.pattern">[-\w ,/\n\&quot;&apos;]{20,200}</str>
                </lst>
            </fragmenter>
            <formatter name="html"
                       default="true"
                       class="solr.highlight.HtmlFormatter">
                <lst name="defaults">
                    <str name="hl.simple.pre"><![CDATA[<em>]]></str>
                    <str name="hl.simple.post"><![CDATA[</em>]]></str>
                </lst>
            </formatter>
            <encoder name="html"
                     class="solr.highlight.HtmlEncoder"/>
            <fragListBuilder name="simple"
                             class="solr.highlight.SimpleFragListBuilder"/>
            <fragListBuilder name="single"
                             class="solr.highlight.SingleFragListBuilder"/>
            <fragListBuilder name="weighted"
                             default="true"
                             class="solr.highlight.WeightedFragListBuilder"/>
            <fragmentsBuilder name="default"
                              default="true"
                              class="solr.highlight.ScoreOrderFragmentsBuilder">
            </fragmentsBuilder>
            <fragmentsBuilder name="colored"
                              class="solr.highlight.ScoreOrderFragmentsBuilder">
                <lst name="defaults">
                    <str name="hl.tag.pre"><![CDATA[
               <b style="background:yellow">,<b style="background:lawgreen">,
               <b style="background:aquamarine">,<b style="background:magenta">,
               <b style="background:palegreen">,<b style="background:coral">,
               <b style="background:wheat">,<b style="background:khaki">,
               <b style="background:lime">,<b style="background:deepskyblue">]]></str>
                    <str name="hl.tag.post"><![CDATA[</b>]]></str>
                </lst>
            </fragmentsBuilder>
            <boundaryScanner name="default"
                             default="true"
                             class="solr.highlight.SimpleBoundaryScanner">
                <lst name="defaults">
                    <str name="hl.bs.maxScan">10</str>
                    <str name="hl.bs.chars">.,!? &#9;&#10;&#13;</str>
                </lst>
            </boundaryScanner>
            <boundaryScanner name="breakIterator"
                             class="solr.highlight.BreakIteratorBoundaryScanner">
                <lst name="defaults">
                    <str name="hl.bs.type">WORD</str>
                    <str name="hl.bs.language">en</str>
                    <str name="hl.bs.country">US</str>
                </lst>
            </boundaryScanner>
        </highlighting>
    </searchComponent>
    <queryResponseWriter name="json" class="solr.JSONResponseWriter">
        <str name="content-type">text/plain; charset=UTF-8</str>
    </queryResponseWriter>
    <queryResponseWriter name="velocity" class="solr.VelocityResponseWriter" startup="lazy"/>
    <queryResponseWriter name="xslt" class="solr.XSLTResponseWriter">
        <int name="xsltCacheLifetimeSeconds">5</int>
    </queryResponseWriter>
    <admin>
        <defaultQuery>*:*</defaultQuery>
    </admin>
</config>
```

- 先按 Ctrl + C 停掉刚刚启动做测试的 solr 程序
- 重启：`cd /usr/program/solr-4.10.2/example/ ; java -Dsolr.solr.home=ssm-solr -jar start.jar`
- 重新访问，我们可以看到新的 Core 已经可以用了。












