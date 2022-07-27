PORTNAME=	dbeaver
DISTVERSION=	g20220725
CATEGORIES=	databases java
PKGNAMESUFFIX=	-dev
DISTNAME=	${PORTNAME}-${GH_TAGNAME}
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

#EPLUGIN_ID=     org.jkiss.dbeaver.core.product
#EPLUGIN_VER=    ${PORTVERSION}
#
MVN_ARGS=	-e \
		-D=tycho.p2.transport=ecf \
		-Dmaven.deploy.skip=true

FIND_HERE=      ${WRKSRC}/product/community/target/products/org.jkiss.dbeaver.core.product
FIND_COND=      -not ( -name README -or -name LICENSE )

WRKSRC=	${WRKDIR}/${PORTNAME}-${GH_TAGNAME}

do-build:
	@cd ${WRKSRC} && ${SETENV} ${MAKE_ENV} \
	${LOCALBASE}/bin/mvn ${MVN_ARGS} eclipse:eclipse package
	
do-install:
	@(cd ${WRKSRC} && ${COPYTREE_SHARE} . ${STAGEDIR}${PREFIX}/lib/eclipse/plugins/${PORTNAME})
#	@(cd ${WRKSRC} && ${COPYTREE_SHARE} . ${STAGEDIR}${PREFIX}/lib/eclipse/plugins/${DISTNAME})
#	cd ${WRKSRC} && ${COPYTREE_SHARE} ${FIND_HERE} ${STAGEDIR} "${FIND_COND}"
#	cd ${WRKSRC} && ${COPYTREE_SHARE} ${FIND_HERE} ${STAGEDIR}${DATADIR} "${FIND_COND}"


# do- tasks found and modified from cad/digital on 20220605
# The -o makes it all an offline operation, meaning no extra fetching.
#do-build:
#	@cd ${WRKSRC} && ${SETENV} ${MAKE_ENV} \
#		${LOCALBASE}/bin/mvn -o ${MVN_ARGS} \
#		-Dmaven.deploy.skip=true \
#		-D=tycho.p2.transport=ecf \
#		package
#
#---------------------------------------------------------------------------------------------------
# How to stop make from looking for a makefile as this uses maven for the build? an empty do-install.
#
#do-install:
#	# install jar
#	${INSTALL_DATA} ${WRKSRC}/target/Digital.jar ${STAGEDIR}${JAVAJARDIR}
#
#	The above two lines may be enough although somehow need to make a list or find where that 'Reactor Summary' comes from?
#
#	# install shell wrapper
#	@(echo "#!/bin/sh"; \
#	echo ""; \
#	echo "${JAVA} -jar ${JAVAJARDIR}/Digital.jar \""$$"@\"" \
#	) > ${STAGEDIR}${PREFIX}/bin/${PORTNAME}
#	@${CHMOD} +x ${STAGEDIR}${PREFIX}/bin/${PORTNAME}
#	# install desktop file
#	${SED} -e '\
#		s|<EXEC_LOCATION>|${PREFIX}/bin/${PORTNAME}| ; \
#		s|<ICON_LOCATION>|${ICON_NAME}|' \
# 		< ${WRKSRC}/distribution/linux/desktop.template \
#		> ${STAGEDIR}${PREFIX}/share/applications/${PORTNAME}.desktop
#
#
#---------------------------------------------------------------------------------------------------
.include <bsd.port.mk>
