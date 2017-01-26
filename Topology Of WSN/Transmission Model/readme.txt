About Models.bmp和Models_Soln_RIM_TOSN.pdf介绍了传播模型.
Parameters_Of_Models.mat 保存了传播模型的参数设置。
实现了4个传播模型: Regular Model, DOI Model, Logarithmic Attenuation Model, RIM Model(参考About Models.bmp）

-----------------------------------------------------------------------------------------------------------------------------------

这四个文件夹下都有dist2rss.m, rss2dist.m两个文件和一个Research On This Model子文件夹：
  ***/dist2rss.m是***模型下距离到信号强度的转换

  ***/rss2dist.m是***模型下信号强度到距离的转换

  ***/Research On This Model/Fig_Of_Model.m是画出***模型下通信区域图的函数或脚本，该函数(在Regular Model，Logarithmic Attenuation Model下不需要参数，在DOI Model, RIM Model下需要参数)需要的参数自己参考Fig_Of_Model.m文件中的说明

  ***/Research On This Model/********.bmp是执行Fig_Of_Model函数后画出的通信区域图

注：
***表示Regular Model, DOI Model, Logarithmic Attenuation Model, RIM Model中的一个
------------------------------------------------------------------------------------------------------------------------------------