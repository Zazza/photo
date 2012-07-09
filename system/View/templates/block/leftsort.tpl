{% if fav %}
<div class="alert alert-info">Favorites</div>
{% elseif sel %}
<div class="alert alert-info">Sort changed</div>
{% endif %}
<p><a onclick="resetSort()" class="btn btn-inverse"><i class="icon-remove-circle icon-white"></i> Reset</a></p>

<script type="text/javascript">
function resetSort() {
	$.ajax({
    	type: "POST",
    	url: '{{ registry.uri }}ajax/photo/',
    	data: "action=delSort",
    	success: function(res) {
    		window.location.href = "{{ registry.siteName }}{{ registry.uri }}fm/";
    	}
    });
}
</script>