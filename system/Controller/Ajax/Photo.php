<?php
class Controller_Ajax_Photo extends Engine_Ajax {
	private $_mphoto;
	private $_muser;
	private $_mfile;
	
	public function __construct() {
		parent::__construct();
		$this->_muser = new Model_User();
		$this->_mfile = new Model_File();
		$this->_mphoto = new Model_Photo();
	}
	
	public function setDesc($params) {
		$x1 = $params["x1"];
		$x2 = $params["x2"];
		$y1 = $params["y1"];
		$y2 = $params["y2"];
		$ws = $params["ws"];
		$desc = $params["desc"];
		$md5 = $params["md5"];

		if ($x1 != "") {
			$this->_mphoto->setDesc($md5, $desc, $x1, $x2, $y1, $y2, $ws);
		} else {
			$this->_mphoto->setTag($md5, $desc);
		}
		
		$desc = $this->_mphoto->getDesc($md5, $ws);
		$tags = $this->_mphoto->getTags($md5);
		
		echo $this->view->render("fm_desc", array("desc" => $desc, "tags" => $tags));
	}
	
	public function getDesc($params) {
		$md5 = $params["md5"];
	
		$desc = $this->_mphoto->getDesc($md5);
		$tags = $this->_mphoto->getTags($md5);
		
		echo $this->view->render("fm_desc", array("desc" => $desc, "tags" => $tags));
	}
	
	public function delTag($params) {
		$id = $params["id"];
		
		$this->_mphoto->delTag($id);
	}
	
	public function delDesc($params) {
		$id = $params["id"];
		
		$this->_mphoto->delDesc($id);
	}
	
	public function getNumNotes($params) {
		$md5 = $params["id"];
		
		echo $this->_mphoto->getNumNotes($md5);
	}
	
	public function getNotes($params) {
		$md5 = $params["id"];

    	$data = $this->_mphoto->getFileText($md5);    	
    	$text = "";
    	foreach($data as $part) {
    		if ($part["uid"] != null) {
    			$uid = $this->_muser->getUserInfo($part["uid"]);
    			$text .= $this->view->render("fm_ftext", array("text" => $part["text"], "date" => $part["timestamp"], "uid" => $uid));
    		}
    	}
    	
    	echo $text;
	}
	
	public function setSel($params) {
		$word = $params["word"];
		
		$sphoto = & $_SESSION["photo"];
		$sphoto["sel"][] = $word;
		
		unset($sphoto["fav"]);
	}
	
	public function setTag($params) {
		$word = $params["word"];
		
		$sphoto = & $_SESSION["photo"];
		$sphoto["tag"][] = $word;
		
		unset($sphoto["fav"]);
	}
	
	public function delSortTag($params) {
		$word = $params["word"];
		
		$sphoto = & $_SESSION["photo"];
		for($i=0; $i<count($sphoto["tag"]); $i++) {
			if ($sphoto["tag"][$i] == $word) {
				unset($sphoto["tag"][$i]);
			}
		}
	}
	
	public function delSortSel($params) {
		$word = $params["word"];
		
		$sphoto = & $_SESSION["photo"];
		for($i=0; $i<count($sphoto["sel"]); $i++) {
			if ($sphoto["sel"][$i] == $word) {
				unset($sphoto["sel"][$i]);
			}
		}
	}
	
	public function favorite($params) {
		$md5 = $params["md5"];
		
		if ($this->_mphoto->favorite($md5)) {
			echo "<img src='" . $this->registry["uri"] . "img/add.png' alt='' /> Image add in favorite list";
		} else {
			echo "<img src='" . $this->registry["uri"] . "img/remove.png' alt='' /> Image delete from favorite list";
		}
	}
	
	public function getFavorite() {
		$sphoto = & $_SESSION["photo"];
		$sphoto["fav"] = 1;
		
		unset($sphoto["sel"]);
		unset($sphoto["tag"]);
	}
	
	public function delFavorite() {
		$sphoto = & $_SESSION["photo"];
		unset($sphoto["fav"]);
	}
	
	public function delSort() {
		$sphoto = & $_SESSION["photo"];
		unset($sphoto["fav"]);
		unset($sphoto["sel"]);
		unset($sphoto["tag"]);
	}
}
?>