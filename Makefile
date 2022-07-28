PORTNAME=	dbeaver
DISTVERSION=	g20220725
CATEGORIES=	databases java
PKGNAMESUFFIX=	-dev
DISTNAME=	org.jkiss.dbeaver.core.product
DIST_SUBDIR=	${PORTNAME}${PKGNAMESUFFIX}

MAINTAINER=	nope@nothere
COMMENT=	Free universal database tool and SQL client

LICENSE=	APACHE20

BUILD_DEPENDS=	mvn:devel/maven \
		eclipse:java/eclipse
RUN_DEPENDS=	eclipse:java/eclipse

USE_JAVA=	yes
JAVA_VERSION=	11
USE_GITHUB=	nodefault
GH_ACCOUNT=	dbeaver
GH_PROJECT=	dbeaver
GH_TAGNAME=	9ef5f219c0402a695354253177fde310799882b8

DATADIR=        ${PREFIX}/lib/eclipse/plugins

#MVN_ARGS=	-e \
#		-D=tycho.p2.transport=ecf \
#		-Dmaven.deploy.skip=true
MVN_ARGS=	-e

FIND_HERE=      product/community/target/products/org.jkiss.dbeaver.core.product/linux/gtk/x86_64
#FIND_HERE=      ${WRKSRC}/product/community/target/products/org.jkiss.dbeaver.core.product/linux/gtk/x86_64
FIND_COND=      -not ( -name README -or -name LICENSE )

WRKSRC=	${WRKDIR}/${PORTNAME}-${GH_TAGNAME}
INSTALL_TARGET=install-strip

PLIST_SUB= \
        ECLIPSE_PLUGINS="lib/eclipse/plugins" \
        DISTNAME="${DISTNAME}"

do-build:
	@cd ${WRKSRC} && ${SETENV} ${MAKE_ENV} \
	${LOCALBASE}/bin/mvn ${MVN_ARGS} eclipse:eclipse package
	
do-install:
	@(cd ${WRKSRC} && ${COPYTREE_SHARE} . ${STAGEDIR}${PREFIX}/lib/eclipse/plugins/${DISTNAME})

#	@(cd ${WRKSRC} && ${COPYTREE_SHARE} ${FIND_HERE} ${STAGEDIR}${PREFIX}/lib/eclipse/plugins/${DISTNAME})
#	@(cd ${WRKSRC} && ${COPYTREE_SHARE} ${FIND_HERE} ${STAGEDIR}${PREFIX}/lib/eclipse/plugins/${PORTNAME})
#	@(cd ${WRKSRC} && ${COPYTREE_SHARE} . ${STAGEDIR}${PREFIX}/lib/eclipse/plugins/${PORTNAME})
#	@(cd ${WRKSRC} && ${COPYTREE_SHARE} . ${STAGEDIR}${PREFIX}/lib/eclipse/plugins/${DISTNAME})
#	cd ${WRKSRC} && ${COPYTREE_SHARE} ${FIND_HERE} ${STAGEDIR} "${FIND_COND}"
#	cd ${WRKSRC} && ${COPYTREE_SHARE} ${FIND_HERE} ${STAGEDIR}${DATADIR} "${FIND_COND}"
#---------------------------------------------------------------------------------------------------
# How to stop make from looking for a makefile as this uses maven for the build? an empty do-install.
#
#
# Warning: 'lib/eclipse/plugins/dbeaver/product/community/target/products/org.jkiss.dbeaver.core.product/linux/gtk/x86_64/dbeaver/dbeaver'
# is not stripped consider trying INSTALL_TARGET=install-strip or using ${STRIP_CMD}
# Warning: 'lib/eclipse/plugins/dbeaver/product/community/target/products/org.jkiss.dbeaver.core.product/linux/gtk/x86_64/dbeaver/
# plugins/org.eclipse.equinox.launcher.gtk.linux.x86_64_1.2.500.v20220509-0833/eclipse_11701.so'
# is not stripped consider trying INSTALL_TARGET=install-strip or using ${STRIP_CMD}
#
#---------------------------------------------------------------------------------------------------
.include <bsd.port.mk>
