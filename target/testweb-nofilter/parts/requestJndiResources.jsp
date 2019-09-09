<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" session="false"
	import="java.io.*,java.util.*,javax.naming.*,org.slf4j.*"%>

<%!
	/**
     * Recursively list the JNDI namespace
     *
     * @param ctx a {@link javax.naming.Context} object.
     * @param parent a {@link java.lang.String} object.
     * @param processed a {@link java.util.List} object.
     * @param base a {@link java.util.Map} object.
     * @return a {@link java.util.Map} object.
     * @throws javax.naming.NamingException if any.
     */
     static final Map<String, Object> mapContext(final Context ctx, final String parent, List<Object> processed, Map<String, Object> base) throws NamingException {
        Logger logger = LoggerFactory.getLogger("requestJndiResources.jsp");
        System.out.println("Looking up bindings for " + parent);
        logger.debug("Looking up bindings for {} from {}", parent, ctx);
        NamingEnumeration<Binding> list = ctx.listBindings(parent);
        String prefix = ((parent != null && !"".equals(parent)) ? parent + "." : "");
        int children = 0;
        while (list.hasMore()) {
            children++;
            Binding nextBinding = list.next();
            String name = nextBinding.getName();
            String className = nextBinding.getClassName();

            try {
                if (processed.contains(nextBinding.getNameInNamespace()))
                    continue;
                if (className.endsWith("Context")) {
                    Context nextCtx = (Context) ctx.lookup(name);
                    String nns = nextCtx.getNameInNamespace();
                    if (processed.contains(nns))
                        continue;
                    processed.add(nns);
                } else
                    processed.add(prefix + name);
            } catch (Exception e) {
                continue;
            }

            if (className.endsWith("Context")) {
                HashMap<String, Object> node = new HashMap<String, Object>();
                base.put(prefix + name, node);
                mapContext((Context) ctx.lookup(name), prefix + name, processed, node).size();
                int nextChildren = mapContext((Context) nextBinding.getObject(), prefix + name, processed, node).size();
                logger.trace("JNDI context [{}]: {}{} of type {} with {} children", children, prefix, name, className, nextChildren);
            } else {
                base.put(prefix + name, ctx.lookup(name));
                logger.trace("JNDI object [{}]: {}{} of type {}", children, prefix, name, className);
            }
        }

        return base;
    }

    static final void findSubContexts(Context ctx, String name, SortedMap<String, Object> found) {
        Logger logger = LoggerFactory.getLogger("requestJndiResources.jsp");
        NameClassPair ncp = null;
        try {
            NamingEnumeration<NameClassPair> ne = ctx.list(name);
            while (ne.hasMoreElements()) {
                ncp = ne.nextElement();
                String str = name + "/" + ncp.getName();
                Object obj = new Object();
                try {
                    obj = ctx.lookup(str);
                } catch (NamingException e) {
                }
                logger.debug("Found {} of type {}", str, obj.getClass().getName());
                if (!found.containsKey(str)) {
                    found.put(str, obj);
                    findSubContexts(ctx, str, found);
                }
            }
        } catch (NamingException e) {
            logger.debug("No names bound under {} ", name);
        }
    }%>
<%
    TreeMap<String, Object> jndiMap = null;
    try {
        Context ctx = new InitialContext();
        //Context envCtx = (Context) ctx.lookup("java:comp/env");
        //jndiMap = mapContext(envCtx, "", new ArrayList<Object>(), new HashMap<String, Object>());
		jndiMap = new TreeMap<String,Object>();
        findSubContexts(ctx, "", jndiMap);
        if (jndiMap != null) {
%>
<ol>
	<%
	    for (Map.Entry<String, Object> entry : jndiMap.entrySet()) {
	%>
	<li><b><span style="text-decoration: underline;"><%=entry.getKey()%></span></b>
		of type <%=entry.getValue().getClass().getName()%></li>
	<%
	    }
	        }
	%>
</ol>
<%
    } catch (Exception e) {
        e.printStackTrace();
        e.printStackTrace(new PrintWriter(out));
    }
%>
