<script runat="server" language="jscript">

var delegates = [];
var currentIndex = 0;

function CreateDelegate(funcName) {
	var v = currentIndex;
	
	delegates[currentIndex] = {
		func: function(params) {
		
			var x = funcName + "(";
			
			for (var index = 0; index < params.length; index++) {
				x += "params[" + index + "]";
				
				if (index < params.length - 1)
					x+= ", ";
			}
			
			x += ");";
		
			return eval(x);
		}
	};

	return currentIndex++;
}

function ExecuteDelegate(id) {
	return delegates[id].func();
}

function ExecuteDelegate1(id, p1) {
	return delegates[id].func([p1]);
}

function ExecuteDelegate2(id, p1, p2) {
	return delegates[id].func([p1, p2]);
}

function ExecuteDelegate3(id, p1, p2, p3) {
	return delegates[id].func([p1, p2, p3]);
}

function ExecuteDelegate4(id, p1, p2, p3, p4) {
	return delegates[id].func([p1, p2, p3, p4]);
}

function ExecuteDelegate5(id, p1, p2, p3, p4, p5) {
	return delegates[id].func([p1, p2, p3, p4, p5]);
}

function CreateBlockDictionary1(p1) {
	var blocks = new ActiveXObject("Scripting.Dictionary");
	blocks.CompareMode = 1;
	
	blocks.Add(p1, CreateDelegate(p1 + "Block"));
	
	return blocks;
}

function CreateBlockDictionary2(p1, p2) {
	var blocks = new ActiveXObject("Scripting.Dictionary");
	blocks.CompareMode = 1;
	
	blocks.Add(p1, CreateDelegate(p1 + "Block"));
	blocks.Add(p2, CreateDelegate(p2 + "Block"));	
	
	return blocks;
}

function CreateBlockDictionary3(p1, p2, p3) {
	var blocks = new ActiveXObject("Scripting.Dictionary");
	blocks.CompareMode = 1;
	
	blocks.Add(p1, CreateDelegate(p1 + "Block"));
	blocks.Add(p2, CreateDelegate(p2 + "Block"));	
	blocks.Add(p3, CreateDelegate(p3 + "Block"));	
	
	return blocks;
}

function CreateBlockDictionary4(p1, p2, p3, p4) {
	var blocks = new ActiveXObject("Scripting.Dictionary");
	blocks.CompareMode = 1;
	
	blocks.Add(p1, CreateDelegate(p1 + "Block"));
	blocks.Add(p2, CreateDelegate(p2 + "Block"));	
	blocks.Add(p3, CreateDelegate(p3 + "Block"));	
	blocks.Add(p4, CreateDelegate(p4 + "Block"));	
	
	return blocks;
}

function CreateBlockDictionary5(p1, p2, p3, p4, p5) {
	var blocks = new ActiveXObject("Scripting.Dictionary");
	blocks.CompareMode = 1;
	
	blocks.Add(p1, CreateDelegate(p1 + "Block"));
	blocks.Add(p2, CreateDelegate(p2 + "Block"));	
	blocks.Add(p3, CreateDelegate(p3 + "Block"));	
	blocks.Add(p4, CreateDelegate(p4 + "Block"));	
	blocks.Add(p5, CreateDelegate(p5 + "Block"));
	
	return blocks;
}

function CreateBlockDictionary6(p1, p2, p3, p4, p5, p6) {
	var blocks = new ActiveXObject("Scripting.Dictionary");
	blocks.CompareMode = 1;
	
	blocks.Add(p1, CreateDelegate(p1 + "Block"));
	blocks.Add(p2, CreateDelegate(p2 + "Block"));	
	blocks.Add(p3, CreateDelegate(p3 + "Block"));	
	blocks.Add(p4, CreateDelegate(p4 + "Block"));	
	blocks.Add(p5, CreateDelegate(p5 + "Block"));
	blocks.Add(p6, CreateDelegate(p6 + "Block"));
	
	return blocks;
}

function CreateBlockDictionary7(p1, p2, p3, p4, p5, p6, p7) {
	var blocks = new ActiveXObject("Scripting.Dictionary");
	blocks.CompareMode = 1;
	
	blocks.Add(p1, CreateDelegate(p1 + "Block"));
	blocks.Add(p2, CreateDelegate(p2 + "Block"));	
	blocks.Add(p3, CreateDelegate(p3 + "Block"));	
	blocks.Add(p4, CreateDelegate(p4 + "Block"));	
	blocks.Add(p5, CreateDelegate(p5 + "Block"));
	blocks.Add(p6, CreateDelegate(p6 + "Block"));
	blocks.Add(p7, CreateDelegate(p7 + "Block"));
	
	return blocks;
}

function CreateBlockDictionary8(p1, p2, p3, p4, p5, p6, p7, p8) {
	var blocks = new ActiveXObject("Scripting.Dictionary");
	blocks.CompareMode = 1;
	
	blocks.Add(p1, CreateDelegate(p1 + "Block"));
	blocks.Add(p2, CreateDelegate(p2 + "Block"));	
	blocks.Add(p3, CreateDelegate(p3 + "Block"));	
	blocks.Add(p4, CreateDelegate(p4 + "Block"));	
	blocks.Add(p5, CreateDelegate(p5 + "Block"));
	blocks.Add(p6, CreateDelegate(p6 + "Block"));
	blocks.Add(p7, CreateDelegate(p7 + "Block"));
	blocks.Add(p8, CreateDelegate(p8 + "Block"));
	
	return blocks;
}

function CreateDictionary1(p1, v1) {
	var d = new ActiveXObject("Scripting.Dictionary");
	d.CompareMode = 1;
	
	d.Add(p1, v1);
	
	return d;
}

function CreateDictionary2(p1, v1, p2, v2) {
	var d = new ActiveXObject("Scripting.Dictionary");
	d.CompareMode = 1;
	
	d.Add(p1, v1);
	d.Add(p2, v2);	
	
	return d;
}

function CreateDictionary3(p1, v1, p2, v2, p3, v3) {
	var d = new ActiveXObject("Scripting.Dictionary");
	d.CompareMode = 1;
	
	d.Add(p1, v1);
	d.Add(p2, v2);	
	d.Add(p3, v3);	
	
	return d;
}
</SCRIPT>