<ul id="treestructure" class="filetree">
	<ul>
		<li>
			<span class='folder' title='d_0'><a class="tbranch" href="{{ registry.uri }}fm/?id=0">Upload</a></span>
			{{ tree }}
		</li>
	</ul>
</ul>

<script type="text/javascript">
$("#treestructure").treeview({
	persist: "location",
	collapsed: false,
	persist: "cookie"
});
</script>