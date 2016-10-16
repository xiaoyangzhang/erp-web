<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%
	String staticPath = request.getContextPath();
%>
<dl class="p_paragraph_content">
	<dd>
		<div class="pl-10 pr-10">
			<table cellspacing="0" cellpadding="0" class="w_table">
				<col width="3%" />
				<col width="10%" />
				<col width="8%" />
				<col width="5%" />

				<col width="7%" />
				<col width="7%" />
				<col width="7%" />
				<col width="7%" />

				<col width="7%" />
				<col width="7%" />
				<col width="7%" />

				<col width="7%" />
				<col width="7%" />
				<col width="7%" />
				<col width="7%" />

				<thead>
					<tr>
						<td rowspan="2">编码<i class="w_table_split"></i></td>
						<td rowspan="2">产品名称<i class="w_table_split"></i></td>
						<td rowspan="2">库存数量<i class="w_table_split"></i></td>

						<td colspan="5">价格设置<i class="w_table_split"></i></td>

						<td rowspan="2">最长预留时间<i class="w_table_split"></i></td>
						<td rowspan="2">取消预留库存下限<i class="w_table_split"></i></td>
						<td rowspan="2">操作<i class="w_table_split"></i></td>
					</tr>
					<tr>
						<td>规格<i class="w_table_split"></i></td>
						<td>建议零售价<i class="w_table_split"></i></td>
						<td>同行返款<i class="w_table_split"></i></td>
						<td>代理返款<i class="w_table_split"></i></td>
						<td>最低定金<i class="w_table_split"></i></td>
					</tr>
				</thead>
				<tbody>
				
				
				</tbody>
			</table>
		</div>
	</dd>
</dl>
