<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<div class="sidebar" id="sidebar">
	<script type="text/javascript">
		try {
			ace.settings.check('sidebar', 'fixed')
		} catch (e) {
		}
	</script>


	<ul id="menu" class="nav nav-list">
		<li><a href="index"> <i class="icon-dashboard"></i> <span
				class="menu-text">菜单管理</span>
		</a></li>

		<li><a href="javascript:void(0)" class="dropdown-toggle"> <i
				class="icon-list"></i> <span class="menu-text">系统管理</span> <b
				class="arrow icon-angle-down"></b>
		</a>
			<ul class="submenu">
				<li><a href="basic/dicTypeIndex.htm" target="mainFrame"> <i
						class="icon-double-angle-right"></i>字典类型管理
				</a></li>
				<li><a href="basic/dicIndex.htm" target="mainFrame"> <i
						class="icon-double-angle-right"></i>字典管理
				</a></li>
				<li><a href="basic/regIndex.htm" target="mainFrame"> <i
						class="icon-double-angle-right"></i>区域管理
				</a></li>
			</ul></li>

		<li><a href="javascript:void(0)" class="dropdown-toggle"> <i
				class="icon-desktop"></i> <span class="menu-text">供应商管理</span> <b
				class="arrow icon-angle-down"></b></a>
			<ul class="submenu">

				<li><a href="javascript:void(0)" class="dropdown-toggle"> <i
						class="icon-double-angle-right"></i>旅行社<b
						class="arrow icon-angle-down"></b>
					</a>
					<ul class="submenu">
						<li><a
							href="supplier/toSuplierList.htm?supplierType=1&page=1"
							target="mainFrame"> <i class="icon-leaf"></i>旅行社列表
						</a></li>
					</ul>
				</li>

				<li><a href="javascript:void(0)" class="dropdown-toggle"> <i
						class="icon-double-angle-right"></i>餐厅<b
						class="arrow icon-angle-down"></b>
				</a>
					<ul class="submenu">
						<li><a
							href="supplier/toSuplierList.htm?supplierType=2&page=1"
							target="mainFrame"> <i class="icon-leaf"></i>餐厅列表
						</a></li>
					</ul></li>
				<li><a href="javascript:void(0)" class="dropdown-toggle"> <i
						class="icon-double-angle-right"></i>酒店<b
						class="arrow icon-angle-down"></b>
				</a>
					<ul class="submenu">
						<li><a
							href="supplier/toSuplierList.htm?supplierType=3&page=1"
							target="mainFrame"> <i class="icon-leaf"></i>酒店列表
						</a></li>
					</ul></li>

				<li><a href="javascript:void(0)" class="dropdown-toggle"> <i
						class="icon-double-angle-right"></i>车队<b
						class="arrow icon-angle-down"></b>
				</a>
					<ul class="submenu">
						<li><a
							href="supplier/toSuplierList.htm?supplierType=4&page=1"
							target="mainFrame"> <i class="icon-leaf"></i>车队列表
						</a></li>
					</ul></li>



				<li><a href="javascript:void(0)" class="dropdown-toggle"> <i
						class="icon-double-angle-right"></i>景区<b
						class="arrow icon-angle-down"></b>
				</a>
					<ul class="submenu">
						<li><a
							href="supplier/toSuplierList.htm?supplierType=5&page=1"
							target="mainFrame"> <i class="icon-leaf"></i>景区列表
						</a></li>
					</ul></li>


				<li><a href="javascript:void(0)" class="dropdown-toggle"> <i
						class="icon-double-angle-right"></i>购物<b
						class="arrow icon-angle-down"></b>
				</a>
					<ul class="submenu">
						<li><a
							href="supplier/toSuplierList.htm?supplierType=6&page=1"
							target="mainFrame"> <i class="icon-leaf"></i>购物列表
						</a></li>
					</ul></li>


				<li><a href="javascript:void(0)" class="dropdown-toggle"> <i
						class="icon-double-angle-right"></i>娱乐<b
						class="arrow icon-angle-down"></b>
				</a>
					<ul class="submenu">
						<li><a
							href="supplier/toSuplierList.htm?supplierType=7&page=1"
							target="mainFrame"> <i class="icon-leaf"></i>娱乐列表
						</a></li>
					</ul></li>



				<li><a href="javascript:void(0)" class="dropdown-toggle"> <i
						class="icon-double-angle-right"></i>导游<b
						class="arrow icon-angle-down"></b>
				</a>
					<ul class="submenu">
						<li><a
							href="supplier/toSuplierList.htm?supplierType=8&page=1"
							target="mainFrame"> <i class="icon-leaf"></i>导游列表
						</a></li>
					</ul></li>


				<li><a href="javascript:void(0)" class="dropdown-toggle"> <i
						class="icon-double-angle-right"></i>机票代理<b
						class="arrow icon-angle-down"></b>
				</a>
					<ul class="submenu">
						<li><a
							href="supplier/toSuplierList.htm?supplierType=9&page=1"
							target="mainFrame"> <i class="icon-leaf"></i>机票代理列表
						</a></li>
					</ul></li>



				<li><a href="javascript:void(0)" class="dropdown-toggle"> <i
						class="icon-double-angle-right"></i>火车票代理<b
						class="arrow icon-angle-down"></b>
				</a>
					<ul class="submenu">
						<li><a
							href="supplier/toSuplierList.htm?supplierType=10&page=1"
							target="mainFrame"> <i class="icon-leaf"></i>火车票代理列表
						</a></li>
					</ul></li>



				<li><a href="javascript:void(0)" class="dropdown-toggle"> <i
						class="icon-double-angle-right"></i>高尔夫<b
						class="arrow icon-angle-down"></b>
				</a>
					<ul class="submenu">
						<li><a
							href="supplier/toSuplierList.htm?supplierType=11&page=1"
							target="mainFrame"> <i class="icon-leaf"></i>高尔夫列表
						</a></li>
					</ul></li>
				


				<li><a href="javascript:void(0)" class="dropdown-toggle"> <i
						class="icon-double-angle-right"></i>其他<b
						class="arrow icon-angle-down"></b>
				</a>
					<ul class="submenu">
						<li><a
							href="supplier/toSuplierList.htm?supplierType=12&page=1"
							target="mainFrame"> <i class="icon-leaf"></i>其他列表
						</a></li>
					</ul></li>
				<li><a href="contract/list.htm" target="mainFrame"> <i
						class="icon-double-angle-right"></i>合同协议
				</a></li>
				<li><a href="globalTemplate" target="mainFrame"> <i
						class="icon-double-angle-right"></i>供应商分组
				</a></li>
				<li><a href="globalTemplate" target="mainFrame"> <i
						class="icon-double-angle-right"></i>供应商回收站
				</a></li>
			</ul></li>

		<li><a href="javascript:void(0)" class="dropdown-toggle"> <i
				class="icon-list"></i> <span class="menu-text">内容管理</span> <b
				class="arrow icon-angle-down"></b>
		</a>

			<ul class="submenu">
				<li><a href="content/toContentIndex" target="mainFrame"> <i
						class="icon-double-angle-right"></i> 内容管理
				</a></li>
			</ul></li>
		<li><a href="#" class="dropdown-toggle"> <i class="icon-list"></i>
				<span class="menu-text">站点管理</span> <b class="arrow icon-angle-down"></b>
		</a>

			<ul class="submenu">
				<li><a href="site/edit" target="mainFrame"> <i
						class="icon-double-angle-right"></i> 站点管理
				</a></li>
			</ul></li>

		<li><a href="#" class="dropdown-toggle"> <i class="icon-edit"></i>
				<span class="menu-text">FTP管理 </span> <b
				class="arrow icon-angle-down"></b>
		</a>

			<ul class="submenu">
				<li><a href="ftp/list" target="mainFrame"> <i
						class="icon-double-angle-right"></i> FTP管理
				</a></li>
			</ul></li>
		<li><a href="#" class="dropdown-toggle"> <i class="icon-list"></i>
				<span class="menu-text">静态资源管理</span> <b
				class="arrow icon-angle-down"></b>
		</a>

			<ul class="submenu">
				<li><a href="res/index" target="mainFrame"> <i
						class="icon-double-angle-right"></i> 静态资源管理
				</a></li>
			</ul></li>
		<li><a href="#" class="dropdown-toggle"> <i class="icon-list"></i>
				<span class="menu-text">静态化</span> <b class="arrow icon-angle-down"></b>
		</a>
			<ul class="submenu">
				<li><a href="staticize/main" target="mainFrame"> <i
						class="icon-double-angle-right"></i> 首页静态化
				</a></li>
				<li><a href="staticize/template" target="mainFrame"> <i
						class="icon-double-angle-right"></i> 模版静态化
				</a></li>
			</ul></li>
	</ul>
	<!-- /.nav-list -->

	<div class="sidebar-collapse" id="sidebar-collapse">
		<i class="icon-double-angle-left" data-icon1="icon-double-angle-left"
			data-icon2="icon-double-angle-right"></i>
	</div>

	<script type="text/javascript">
		try {
			ace.settings.check('sidebar', 'collapsed')
		} catch (e) {
		}
	</script>
</div>
