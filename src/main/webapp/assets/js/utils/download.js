/**
 * 文件下载
 * @param url
 * @param name
 */
function downloadFile (url, name){
	name = name.replace(/[&=,]/g, '');
	window.open(getContextPath() + "/component/download.htm?path="+encodeURI(url)+"&name="+encodeURI(encodeURI(name)));
}