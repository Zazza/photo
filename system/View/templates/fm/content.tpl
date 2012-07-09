<div id="fmTop">
	<div style="float: left; margin-right: 20px"><b>Current dir: [{{ shPath }}]</b></div>
	<div style="float: left">
		<div id="servSel">
			<div id="fm_sel" class="btn"><img style="vertical-align: middle" src="{{ registry.uri }}img/plus.png" /> Select All</div>
			<div id="fm_unsel" class="btn"><img style="vertical-align: middle" src="{{ registry.uri }}img/minus.png" /> Unselect All</div>
		</div>
	</div>
	<div style="float: right"><b>Size:</b> <span id="fm_total">{{ totalsize }}</span></div>
</div>

<div style="overflow: hidden">

{% set i = 0 %}
{% for part in dirs %}
{% if part.name != ".." %}
{% set i = i + 1 %}

{% if part.close %}{% set opacity = "; opacity: 0.2;" %}{% else %}{% set opacity = "; opacity: 1.0;" %}{% endif %}

<div class="fm_dirs fm_dirs{{ i }}" title="{{ part.name }}" id="d_{{ part.id }}"  style="text-align: center; cursor: pointer">
<div class="fm_unsellabel">
	<div ondblClick="chdir('{{ part.id }}')"><img src="{{ registry.uri }}img/ftypes/folder.png" style="width: 170px{{ opacity }}" alt="[DIR]" /></div>
	<div ondblClick="chdir('{{ part.id }}')" class="dname">{{ part.name }}</div>
</div>
</div>
{% else %}
<div class="fm_dirs_up" title="{{ part.name }}" style="text-align: center; cursor: pointer">
	<div ondblClick="chdir('{{ part.pid }}')"><img src="{{ registry.uri }}img/ftypes/folder.png" style="width: 170px{{ opacity }}" alt="[DIR]" /></div>
	<div ondblClick="chdir('{{ part.pid }}')">[..]</div>
</div>
{% endif %}
{% endfor %}

<div id="fm_uploadDir">

{% for part in files %}
{% set i = i + 1 %}

{% if part.close %}{% set opacity = "; opacity: 0.2;" %}{% else %}{% set opacity = "; opacity: 1.0;" %}{% endif %}

<div id="fm_file{{ i }}" title="{{ part.name }}" md5="{{ part.md5 }}" class="fm_file" style="text-align: center; cursor: pointer">
<div class="fm_unsellabel">
	<a rel="group" href="{{ registry.uri }}{{ registry.path.upload }}{{ part.md5 }}" class="fm_pre fancybox" name="{{ part.md5 }}" id="fm_filename{{ i }}"><img src="{{ registry.uri }}{{ part.ico }}" style="height: 170px{{ opacity }}" alt="[FILE]" /></a>
	<div class="fname">{{ part.shortname }}</div>
	<div class="fullname" style="display: none">{{ part.name }}</div>
	
	<div style="color: #777">size:&nbsp;{{ part.size }}</div>
	<div id="fs_{{ part.id }}" style="color: green; font-weight: bold; {% if part.share %}display: block{% else %}display: none{% endif %}">Share</div>
</div>
</div>
{% endfor %}
</div>

</div>

<input name="lastIdRow" id="fm_lastIdRow" value="{{ i }}" type="hidden" />
<input name="max" id="fm_max" value="{{ i }}" type="hidden" />
<input type="hidden" id="md5" />

{{ fsRes }}

<script type="text/javascript">
var slideimg = "{{ registry.uri }}img/play.png";
var jcrop_api;

$(function(){
	var fsRes = $("#fsRes").html();
	$("#fsRes").remove();
	
	$(".fancybox").click(function() {
		$(".fancybox").fancybox({
			"width" : '100%',
			"height" : '100%',
			'fitToView': true,
			'openEffect'  : 'none',
	        'closeEffect' : 'none',
	        'nextEffect'  : 'fade',
	        'prevEffect'  : 'fade',
	        'mouseWheel ' : 'true',
	        'arrows': false,
	        helpers:  {
	            title: 'outside'
	        },
	        'beforeShow': function() {
				this.title = fsRes;
	        },
	        'afterShow': function() {
	        	if ($('.fancybox-image').width()) {
	        		count = this.href.lastIndexOf("/");
	        		md5 = this.href.substr(count+1);
	        	} else {
	        		md5 = $(".fancybox").attr("name");
	        	}
	        	var name = $(".fm_file[md5='" + md5 + "']").attr("title");
	        	$("#pFname").text(name);
	        	var res = selPic(md5);
	        	$("#ajaxdesc").html(res);
				
	        	getNumNotes(md5);
	        	
	        	$("#slideimg").attr("src", window.slideimg);
	        	
	        	$('.fancybox-image').Jcrop({
	    			onSelect: showCoords,
	                onChange: showCoords
	    	    }, function(){
	    			jcrop_api = this;
	    	 	});
	        }
		});
	});
		
	{% if clip %}
	$("#clip").html("{{ clip }}");
	{% else %}
	$("#clip").html("<li style='text-align: center'>empty</li>");
	{% endif %}
	
	{% if admin %}
	$("#admbtn").removeClass("btn-danger").addClass("btn-success");
	$("#adminFunc").show();
	{% else %}
	$("#admbtn").removeClass("btn-success").addClass("btn-danger");
	$("#adminFunc").hide();
	{% endif %}
});

function overAXIS(x1, y1, x2, y2, width) {
	var ws = $('.fancybox-image').width() / width;
	ws = ws.toFixed(2);
	
	jcrop_api.setOptions({
        onSelect:    showCoords,
        bgColor:     'black',
        bgOpacity:   .4,
        setSelect:   [x1 * ws, y1 * ws, x2 * ws, y2 * ws]
    });
}

function outAXIS() {
	jcrop_api.release();
	jcrop_api.setOptions({ allowSelect: true });
	
	clearCoords();
	
    return false;
}

function selPic(md5) {
	$("#md5").val(md5);

	var data = "action=getDesc&md5=" + md5;

	$.ajax({
    	type: "POST",
    	url: '{{ registry.uri }}ajax/photo/',
    	data: data,
    	async: false,
    	success: function(res) {
    		tmp = res;
    	}
    });
	
	return tmp;
}

function showCoords(c) {
    $("#x1").val(c.x);
    $("#y1").val(c.y);
    $("#x2").val(c.x2);
    $("#y2").val(c.y2);
};

function clearCoords() {
    $("#x1").val('');
    $("#y1").val('');
    $("#x2").val('');
    $("#y2").val('');
};

function slidePlay() {
	if ($("#slideimg").attr("src") == "{{ registry.uri }}img/play.png") {
		$("#slideimg").attr("src", "{{ registry.uri }}img/pause.png");
		window.slideimg = "{{ registry.uri }}img/pause.png";
	} else {
		$("#slideimg").attr("src", "{{ registry.uri }}img/play.png");
		window.slideimg = "{{ registry.uri }}img/play.png";
	}
	
	$.fancybox.play();
}

function favorite() {
	var data = "action=favorite&md5=" + $("#md5").val();

	$.ajax({
    	type: "POST",
    	url: '{{ registry.uri }}ajax/photo/',
    	data: data,
    	async: false,
    	success: function(res) {
    		$("<div title='Message'>" + res + "</div>").dialog({
    			zIndex: 10000,
    			width: 250,
    			height: 150,
    			buttons: {
    				"Close": function() {
    					$(this).dialog("close");
    				}
    			}
    		});
    	}
    });
}

function saveSort() {
	var ws = $('.fancybox-image').width();
	
	var data = "action=setDesc&x1=" + $("#x1").val() + "&x2=" + $("#x2").val() + "&y1=" + $("#y1").val() + "&y2=" + $("#y2").val() + "&md5=" + $("#md5").val() + "&desc=" + $("#pdesc").val() + "&ws=" + ws;

	$.ajax({
    	type: "POST",
    	url: '{{ registry.uri }}ajax/photo/',
    	data: data,
    	success: function(res) {
    		$("#ajaxdesc").html(res);
    	}
    });
}

function delTag(id) {
	var data = "action=delTag&id=" + id;

	$.ajax({
    	type: "POST",
    	url: '{{ registry.uri }}ajax/photo/',
    	data: data,
    	async: false,
    	success: function(res) {
    		$("#ptag_" + id).hide();
    	}
    });
}

function delDesc(id) {
	var data = "action=delDesc&id=" + id;

	$.ajax({
    	type: "POST",
    	url: '{{ registry.uri }}ajax/photo/',
    	data: data,
    	async: false,
    	success: function(res) {
    		$("#pdesc_" + id).hide();
    	}
    });
}

function showNotes() {
	var data = "action=getNotes&id=" + $("#md5").val();

	$.ajax({
    	type: "POST",
    	url: '{{ registry.uri }}ajax/photo/',
    	data: data,
    	async: false,
    	success: function(res) {
    		tmp = res;
    	}
    });
	
	$("#resNotes").html(tmp);
	
	$("#pNotes").dialog({
		zIndex: 10000,
		width: 380,
		height: 600,
		buttons: {
			"Закрыть": function() {
				$(this).dialog("close");
			}
		}
	});

}

function getNumNotes(id) {
	var data = "action=getNumNotes&id=" + id;

	$.ajax({
    	type: "POST",
    	url: '{{ registry.uri }}ajax/photo/',
    	data: data,
    	async: false,
    	success: function(res) {
    		$("#numNotes").text(res);
    	}
    });
}

$("#fm_sel").click(function() {
    $(".fm_unsellabel").removeClass("fm_unsellabel").addClass("fm_sellabel");
});

$("#fm_unsel").click(function() {
    $(".fm_sellabel").removeClass("fm_sellabel").addClass("fm_unsellabel");
});
	
$(".fm_unsellabel").live("click", function(){
    $(this).removeClass("fm_unsellabel").addClass("fm_sellabel");
});
	
$(".fm_sellabel").live("click", function(){
    $(this).removeClass("fm_sellabel").addClass("fm_unsellabel");
});

function getCol() {
	var col = 0;
	for (i = 1; i <= parseInt($("#fm_max").val()); i++) {
    	if ($(".fm_dirs" + i + " > div").attr("class") == "fm_sellabel") {
    		col++;
    	};
    	
        if ($("#fm_file" + i + " > div").attr("class") == "fm_sellabel") {
        	col++;
        }
    };
    
    return col;
}

function restore() {
	var selfiles = "";
    for (i = 1; i <= parseInt($("#fm_max").val()); i++) {
    	if ($(".fm_dirs" + i + " > div").attr("class") == "fm_sellabel") {
    		var did = $(".fm_dirs" + i + "").attr("id");
    		selfiles += "&dir[]" + "=" + did.substr(2);
    	};
    	
        if ($("#fm_file" + i + " > div").attr("class") == "fm_sellabel") {
            selfiles += "&file[]" + "=" + encodeURIComponent($("#fm_filename" + i + "").attr("name"));
        }
    };

	$.ajax({
		type: "POST",
		url: '{{ registry.uri }}/ajax/fm/',
		data: "did={{ curdir }}&action=restore&" + selfiles,
		success: function(res) {
			$("#fm_filesystem").html(res);
		}
	});
}


function delmany() {
    for (i = 1; i <= parseInt($("#fm_max").val()); i++){
    	if ($(".fm_dirs" + i + " > div").attr("class") == "fm_sellabel") {
    		deldir($(".fm_dirs" + i + "").attr("id"), $(".fm_dirs" + i + "").attr("title"));
    	};
    	
        if ($("#fm_file" + i + " > div").attr("class") == "fm_sellabel") {
            del($("#fm_filename" + i + "").attr("name"), "fm_file" + i);
        }
    };
    
    update();
};

function delmanyrealConfirm() {
	$('<div title="Remove">You really want to remove files without restoration possibility?</div>').dialog({
		buttons: {
			"Yes": function() { delmanyreal(); $(this).dialog("close"); },
			"No": function() { $(this).dialog("close"); }
		},
		width: 350,
		height: 200
	});
};

function delmanyreal() {
    for (i = 1; i <= parseInt($("#fm_max").val()); i++){
    	if ($(".fm_dirs" + i + " > div").attr("class") == "fm_sellabel") {
    		deldirReal($(".fm_dirs" + i + "").attr("id"));
    	};
    	
        if ($("#fm_file" + i + " > div").attr("class") == "fm_sellabel") {
            delReal($("#fm_filename" + i + "").attr("name"), "fm_file" + i);
        }
    };
    
    update();
}

function copyFiles() {
    var selfiles = "";
    for (i = 1; i <= parseInt($("#fm_max").val()); i++) {
    	if ($(".fm_dirs" + i + " > div").attr("class") == "fm_sellabel") {
    		var did = $(".fm_dirs" + i + "").attr("id");
    		selfiles += "&dir[]" + "=" + did.substr(2);
    	};
    	
        if ($("#fm_file" + i + " > div").attr("class") == "fm_sellabel") {
            selfiles += "&file[]" + "=" + encodeURIComponent($("#fm_filename" + i + "").attr("name"));
        }
    };

	$.ajax({
		type: "POST",
		url: '{{ registry.uri }}/ajax/fm/',
		data: "did={{ curdir }}&action=copyFiles&" + selfiles,
		success: function(res) {
	        $("#clip").html(res);
		}
	});
}

$(".fm_file").contextMenu('fileMenu', {
    bindings: {
      'rm_open': function(t) {
		window.location.href = "{{ registry.uri }}attach/?did={{ curdir }}&filename=" + encodeURIComponent(t.title);
      },
      'rm_rename': function(t) {
		fileRename($(t).attr("md5"), t.title); 
      },
      'rm_main': function(t) {
		getfInfo(t.title, $(t).attr("md5"), 0); 
      },
      'rm_right': function(t) {
		getfInfo(t.title, $(t).attr("md5"), 2); 
      }
    }
});

$(".fm_dirs").contextMenu('dirMenu', {
    bindings: {
      'rd_open': function(t) {
		var id = t.id; 
		id = id.substr(2);
		chdir(id);

      },
      'rd_rename': function(t) {
		dirRename(t.id);
      },
      'rd_right': function(t) {
		shDirRight(t.id);
      }
    }
})
</script>
