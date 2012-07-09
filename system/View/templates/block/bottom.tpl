<span style="float: left; margin-right: 10px" class="btn btn-primary" onclick="shUploader()">
	<img src="{{ registry.uri }}img/upload2.png" alt="" /> Upload files
</span>

<span style="float: left" onclick="copyFiles()" class="btn" id="btnCopy">
	<img src="{{ registry.uri }}img/copy.png" alt="" /> Copy
</span>

<span style="float: left" onclick="pastFiles()"  class="btn" id="btnPast">
	<img src="{{ registry.uri }}img/paste.png" alt="" /> Past
</span>

<ul class="dropdown dropdown-horizontal dropdown-upward">
<li class="topmenubutton" style="cursor: default">
<img src="{{ registry.uri }}img/clipboard.png" alt="" />
<a style="cursor: default" class="dir">Buffer</a>
<ul id="clip"></ul>
</li>
</ul>

<span style="float: left" onclick="createDirDialog()" class="btn">
	<img src="{{ registry.uri }}img/add.png" alt="" /> Create
</span>

<span style="float: left" onclick="delmany()" class="btn">
	<img src="{{ registry.uri }}img/remove.png" alt="" /> Remove
</span>

{% if registry.ui.admin %}
<span onclick="admin()" id="admbtn" class="btn btn-danger" style="float: left; margin-left: 10px">"Admin" Mode</span>


<div id="adminFunc" style="display: none; float: right">

		<span onclick="delmanyrealConfirm()" class="btn btn-danger"> <i
			class="icon-remove icon-white"></i>
			Full Remove
		</span>

		<span onclick="restore()" class="btn btn-success"> <i
			class="icon-repeat icon-white"></i>
			Repair
		</span>
</div>
{% endif %}
