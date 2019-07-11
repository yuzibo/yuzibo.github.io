---
title: c4-ep3网络培训总结
category: network
layout: post
---

# c4-ep3竞赛要求
参赛指南 赛题 赛题名称 软件定义网络性能验证平台

赛题背景 思博伦通信（SPIRENT）参与了国内外几乎所有的运营商级软件定义网络（SDN）的概念验证、选型测试、网络验收及业务部署等生命周期各个阶段的测试工作，相对于传统TCP/IP网络，SDN的挑战往往来自于集中控制和分布式实施带来的性能问题，如何在SDN网络部署之前完成相关控制器的功能及性能测试、组网规模验证是目前SDN运营方面急待解决的问题。 本题目旨在采用虚拟化技术帮助业界实现灵活的SDN相关评估测试方案，为未来的SDN新技术拓展及部署提供更加便捷的技术验证手段。  赛题要求 采用软件定义网络及虚拟化技术，可使用开源软件和框架设计，通过软件定义的方式，灵活定制生成符合特定要求的虚拟仿真SDN网络，对流经SDN网络的数据流量进行分析识别、分类处理；思博伦可向参赛队伍提供专业的Spirent TestCenter虚拟化测试仪，对数据流量进行指标评测，验证数据流量的分析识别、分类处理是否正确。 在实现基本功能的基础上，还需满足如下具体要求：

1. SDN网络节点可以是交换机或路由器，但节点数目不少于6个，如果能够基于参数来灵活定制网络拓扑、规模更好；
2. 通过Python，RestAPI等编程方式实现对SDN网络的相关控制，包括但不限于：拓扑生成、流表下发、链路控制等；
3. 评估方案中SDN网络端到端的转发带宽及转发时延；
4. 评估方案中SDN网络的流表性能，包括：流表容量、流表收敛时间等；
5. 图形化显示生成的虚拟网络拓扑、动态标注流量转发路径，实现该评估方案的可视化。

# 培训视频记录

EP3思博伦赛项系列讲座之一: SDN/openflow网络架构及其部署-参考案例简介 [第一期录屏](https://spirent.zoom.us/recording/share/bKLhAYs2818N4cgTyROAF9mFfA_3_AniMtHvWvgOdqqwIumekTziMw)

EP3思博伦赛项系列讲座之二: 从测试的角度看网络[第二期录屏](https://spirent.zoom.us/recording/play/U8KqJGND7P5mIULfNm0SiS516onq7GrFrODKwdrQZkBAgWvAd9LNm1FogKHWSfia?continueMode=true)

EP3思博伦赛项系列讲座之三: STCa的配置与安装[第三期录屏](https://spirent.zoom.us/recording/play/PrSC4rLLzP750qm6On0ULYknrjNztWYGg0U26eaCzX1NwDTpjAfL0DdrTtQSDyJH?continueMode=true)

EP3思博伦赛项系列讲座之四：网络测试领域“旗舰”工具Spirent TestCenter简介 [第四期录屏](https://spirent.zoom.us/recording/share/LWOOwzMM9EbjEPqdWo8IbgNckIe9ZoR7l_OQa1CoSXY)

仅供参考，不保证信息的准确，有问题请联系 yuzibode#126.com (#=>@)

学习之前一定定一个目标才可以.
# sdn基础知识

转载[packet_in and  packet_out](https://www.cnblogs.com/mrwuzs/p/10366269.html)

##  packet_in

使用Packet-In消息的目的是为了将到达OpenFlow交换机的数据包发送至OpenFlow控制器。以下2种情况即可发送Packet-In消息

	不存在与流表项一致的项目时（Table-miss），OFPR_NO_MATCH
	匹配的流表项中记载的行动为“发送至OpenFlow控制器”时，OFPR_ACTION

发送Packet-In消息时OpenFlow交换机分为两种情况，一种是缓存数据包，一种是不缓存数据包。如果不通过OpenFlow交换机缓存数据包，那么Packet-In消息的buffer_id字段设置为-1，将整个数据包发送至OpenFlow控制器。 如果通过OpenFlow交换机缓存数据包，那么以通过SET_CONFIG消息设置的miss_send_len为最大值的数据包数据将发送至OpenFlow控制器。 miss_send_len的默认值为128。未实施SET_CONFIG消息的交换时，使用该默认值

## packet_out

cket-Out消息是从OpenFlow控制器向OpenFlow交换机发送的消息，是包含数据包发送命令的消息”。 若OpenFlow交换机的缓存中已存在数据包，而OpenFlow控制器发出“发送该数据包”的命令时，该消息指定了表示相应数据包的buffer_id。使用Packet-Out消息还可将OpenFlow控制器创建的数据包发送至OpenFlow交换机。此时，buffer_id置为-1，在Packet-Out消息的最后添加数据包数据。

