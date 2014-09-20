#include "ProtoplugDir.h"

ProtoplugDir* ProtoplugDir::pInstance = 0; 

// private contructor called once
ProtoplugDir::ProtoplugDir()
{
	found = true;
	File pluginLocation = File::getSpecialLocation(File::currentExecutableFile);
	#if JUCE_MAC
    //if (ret.getFullPathName().endsWith("/Contents/MacOS")) // assume OSX bundle format
	pluginLocation = pluginLocation.getSiblingFile("../../../");
	#endif
	dirTextFile = pluginLocation.getSiblingFile("ProtoplugFiles.txt");
	String protoPath = dirTextFile.loadFileAsString();
	if (protoPath.isNotEmpty() && File::isAbsolutePath(protoPath))
		dir = File(protoPath);
	if (dir.exists())
		return;
	dir = pluginLocation.getSiblingFile("ProtoplugFiles");
	if (dir.exists())
		return;
	dir = pluginLocation.getSiblingFile("protoplug");
	if (dir.exists()) 
		return;
	// ProtoplugFiles not found
	found = false;
	dir = pluginLocation.getParentDirectory();
}

bool ProtoplugDir::checkDir(File _dir, String &missing)
{
	bool valid = true;
	StringArray requiredFiles;
	requiredFiles.add("effects");
	requiredFiles.add("generators");
	requiredFiles.add("include");
	requiredFiles.add("effects/default.lua");
	requiredFiles.add("generators/default.lua");
	for (int i = 0; i < requiredFiles.size(); ++i)
	{
		if (!_dir.getChildFile(requiredFiles[i]).exists()) {
			valid = false;
			missing = requiredFiles[i];
			break;
		}
	}
	return valid;
}

void ProtoplugDir::setDir(File _dir)
{
	found = true;
	dir = _dir;
}

File ProtoplugDir::getDir()
{
	return dir;
}

File ProtoplugDir::getDirTextFile()
{
	return dirTextFile;
}

File ProtoplugDir::getScriptsDir()
{
	return getDir().getChildFile(SCRIPTS_DIR);
}

File ProtoplugDir::getLibDir()
{
	return getDir().getChildFile("lib");
}

ProtoplugDir* ProtoplugDir::Instance()
{
	if (!pInstance)
		pInstance = new ProtoplugDir;

	return pInstance;
}
