PORTNAME=	dbeaver
DISTVERSION=	g20230831
CATEGORIES=	databases java
PKGNAMESUFFIX=	-dev
DISTNAME=	org.jkiss.dbeaver.core.product
DIST_SUBDIR=	${PORTNAME}${PKGNAMESUFFIX}

MAINTAINER=	nope@nothere
COMMENT=	Free universal database tool and SQL client

LICENSE=	APACHE20

BUILD_DEPENDS=	mvn:devel/maven \
                eclipse:java/eclipse
RUN_DEPENDS=    eclipse:java/eclipse

USE_JAVA=	yes
JAVA_VERSION=	17
# Does the above handle the need of java/openjdk17-jre
# Does this fail to override a default JAVA version?
# If eclipse and maven are both built after openjdk17-jre and openjdk17 are installed, this built.
# Did something change with upstream for g20230831?
# It needs class 61.0 which correlates to version 17
# outdated JAVA Version will cause failure -- check git readme.md periodically
USE_GITHUB=	nodefault
GH_ACCOUNT=	dbeaver
GH_PROJECT=	dbeaver
GH_TAGNAME=	f4ad598e77345891cb86e655048855ae866bf249

DATADIR=	${PREFIX}/lib/eclipse/plugins

#MVN_ARGS=	-e -P linux -D=tycho.p2.transport=ecf -D=javacpp.platform=linux-x86_64
#MVN_ARGS=	-e -D=tycho.p2.transport=ecf

FIND_HERE=	product/community/target/products/org.jkiss.dbeaver.core.product/linux/gtk/x86_64/dbeaver

# Due to an unknown reason the directory used icludes an old commit hash:
#WRKSRC=	${WRKDIR}/${PORTNAME}-ba98288616e3071f920e38ea2008edb7f3f3cb81
WRKSRC=	${WRKDIR}/${PORTNAME}-${GH_TAGNAME}
INSTALL_TARGET=install-strip

PLIST_SUB= \
	ECLIPSE_PLUGINS="lib/eclipse/plugins" \
	DISTNAME="${DISTNAME}"
pre-build:
	@cd ${WRKSRC} && ${SETENV} ${MAKE_ENV} \
	${LOCALBASE}/bin/mvn -q clean

do-build:
	@cd ${WRKSRC} && ${SETENV} ${MAKE_ENV} \
	${LOCALBASE}/bin/mvn  ${MVN_ARGS} eclipse:eclipse package

do-install:
	@(cd ${WRKSRC}/${FIND_HERE} && ${COPYTREE_BIN} . ${STAGEDIR}${PREFIX}/lib/eclipse/plugins/${DISTNAME}/dbeaver/dbeaver)
	@(cd ${WRKSRC}/${FIND_HERE} && ${COPYTREE_SHARE} . ${STAGEDIR}${PREFIX}/lib/eclipse/plugins/${DISTNAME})

.include <bsd.port.mk>
