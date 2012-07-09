<div style="width: 15%; border-top: 1px solid #EEE; padding-top: 10px; position: fixed; bottom: 70px; ">
{% if registry.auth %}
	<p><img src="{{ registry.uri }}img/star.png" alt="" /> <a onclick="getFavorite()" style="cursor: pointer; color: black; font-weight: bold; text-decoration: underline;">Favorite</a></p>
{% endif %}
	<p><img src="{{ registry.uri }}img/group.png" alt="" /> <a href="{{ registry.siteName }}{{ registry.uri }}fm/?group=sel" style="color: black; font-weight: bold; text-decoration: underline;">Selected</a></p>
	<p><img src="{{ registry.uri }}img/binoculars.png" alt="" /> <a href="{{ registry.siteName }}{{ registry.uri }}fm/?group=tags" style="color: black; font-weight: bold; text-decoration: underline;">Tags</a></p>
</div>