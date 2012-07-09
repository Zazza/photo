<?php
class Model_Save extends Engine_Model {
	private $filename = null;
	public $md5 = null;

	function save() {
		$fm = & $_SESSION["fm"];
    	if (!isset($fm["dir"])) {
    		$curdir = 0;
    	} else {
    		$curdir = $fm["dir"];
    	}

		$sql = "INSERT INTO fm_fs (`md5`, `filename`, `pdirid`, `size`) VALUES (:md5, :filename, :curdir, :size)";
		 
		$res = $this->registry['db']->prepare($sql);
		$param = array(":md5" => $this->md5, ":filename" => $this->filename, ":curdir" => $curdir, ":size" => $this->getSize());
		$res->execute($param);
			
		$fid = $this->registry['db']->lastInsertId();
			
		$sql = "INSERT INTO fm_fs_chmod (fid, `right`) VALUES (:fid, :json)";

		$res = $this->registry['db']->prepare($sql);
		$param = array(":fid" => $fid, ":json" => '{"frall":"2"}');
		$res->execute($param);

		$sql = "INSERT INTO fm_fs_history (fid, uid) VALUES (:fid, :uid)";
		 
		$res = $this->registry['db']->prepare($sql);
		$param = array(":fid" => $fid, ":uid" => $this->registry["ui"]["id"]);
		$res->execute($param);

		$target = $this->registry['path']['root'] . "/" . $this->registry['path']['upload'] . $this->md5;
		
		move_uploaded_file($_FILES['Filedata']['tmp_name'], $target);

		return true;
	}

	function getExt() {
		$ext = end(explode('.', strtolower($_FILES['Filedata']['name'])));
		
		$this->filename = $_FILES['Filedata']['name'];
		$this->md5 = md5($this->filename . date("YmdHis")) . "." . $ext;

		return $ext;
	}

	function getSize() {
		return $_FILES['Filedata']['size'];
	}
	
	function handleUpload($uploadDirectory, $_thumbPath, $replaceOldFile = FALSE) {		 
        if (!is_writable($uploadDirectory)){
            return array('error' => "Server error. Write in a directory is impossible!");
        }

        $ext = $this->getExt();

        if ($this->save()) {
            if ( (strtolower($ext) == "gif") or (strtolower($ext) == "png") or (strtolower($ext) == "jpg") or (strtolower($ext) == "jpeg") ) {
                $thumb = new Model_Thumb();
                $thumb->img_resize($uploadDirectory . $this->md5, $_thumbPath . $this->md5, $this->registry["fm"]["pre_width"], $this->registry["fm"]["pre_height"]);
            };
            
            return array('success' => true);
        } else {
            return array('error' => 'It is impossible to save the file.' .
                'Cancelled, server error');
        }
        
    }
}
?>
