redef exit_only_after_terminate = T;

# Try redefs of table_expire_interval and the
# expiration interval:
const expire_ival = 5 secs &redef;

global t_0 = current_time();
global idx: count = 0;

# Expiration function: for an expiring element, show current time since Zeek
# start, the expiring index, and the actual lifespan of the member.
function expire(tbl: table[count] of time, i: count): interval
	{
	local t_now = current_time();
	print fmt("%7.3f  -%2d, %7.3fs", t_now - t_0, i, t_now - tbl[i]);
	return 0 sec;
	}

# A table mapping from our index counter to the time the item got added.
global g_tbl: table[count] of time &create_expire=expire_ival &expire_func=expire;

# This runs once per second, inserting a new item into the table.
# It prints the time since start of Zeek and new member index.
event tick()
	{
	local t_now = current_time();
	g_tbl[++idx] = t_now;
	print fmt("%7.3f  +%2d", t_now - t_0, idx);
	schedule 1 sec { tick() };
	}

event zeek_init()
	{
	schedule 0 sec { tick() };
	}
