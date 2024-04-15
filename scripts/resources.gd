extends Object
class_name Resources

static func full_path(dir: DirAccess, filename: String):
	if OS.has_feature("web") or OS.has_feature("macos") or OS.has_feature("windows"): # HAX: workaround web resources loading on web bug
		return dir.get_current_dir() + "/" + filename.trim_suffix(".remap")
	return dir.get_current_dir() + "/" + filename

static func load_resources(dirname: String) -> Array[Resource]:
	var result: Array[Resource] = [] 
	var dir = DirAccess.open(dirname)
	for file in dir.get_files():
		var path = full_path(dir, file)
		print("Loading ", path)
		result.push_back(ResourceLoader.load(path))
	return result
	
