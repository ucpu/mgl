#include <unordered_map>
#include <string>

#include "glcorearb.h"

namespace
{
	std::unordered_map<std::string, void*> globalTable;

	void initializeTable()
	{
		globalTable.clear();
		globalTable.reserve(1500);
#include "function_table_data.inl"
	}
}

extern "C"
{
	void MGLfunctionTableInitialize(void)
	{
		initializeTable();
	}

	void *MGLfunctionTableFind(const char *name)
	{
		const std::string n(name);
		auto it = globalTable.find(n);
		if (it == globalTable.end())
			return nullptr;
		return it->second;
	}
}
