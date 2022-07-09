PORTNAME=	dbeaver
DISTVERSION=	g20220708
CATEGORIES=	databases java
PKGNAMESUFFIX=	-dev
DISTNAME=	${PORTNAME}-${GH_TAGNAME}
DIST_SUBDIR=	${PORTNAME}${PKGNAMESUFFIX}

MAINTAINER=	nope@nothere
COMMENT=	Free universal database tool and SQL client

LICENSE=	APACHE20

BUILD_DEPENDS=	mvn:devel/maven
RUN_DEPENDS=	eclipse:java/eclipse

USE_JAVA=	yes
JAVA_VERSION=	11
USE_GITHUB=	nodefault
GH_ACCOUNT=	dbeaver
GH_PROJECT=	dbeaver
GH_TAGNAME=	de087adc8ecee8a86eacfe22f2f08235077427c4

WRKSRC=	${WRKDIR}/${PORTNAME}-${GH_TAGNAME}

# do- tasks found and modified from cad/digital on 20220605
# The -o makes it all an offline operation, meaning no extra fetching.
do-build:
	@cd ${WRKSRC} && ${SETENV} ${MAKE_ENV} \
		${LOCALBASE}/bin/mvn -o ${MVN_ARGS} \
		-Dmaven.deploy.skip=true \
		-D=tycho.p2.transport=ecf \
		package
do-install:

# It seems that maven may need to be freshly installed before this will build?  Is this due to other issues with java/jdk?
# if the command ended with the tycho line it succeeded except install?
# I think Binaries are in product/community/target/products/* as listed by "Reactor Summary" but is that all of them?
#
# How to stop make from looking for a makefile as this uses maven for the build? an empty do-install.
#
# work/dbeaver-328c723e284e0b032e5fe0707e8cc5a4d60c8223/product/community/target/products/org.jkiss.dbeaver.core.product/linux/gtk/x86_64/dbeaver
#do-install:
	# install jar
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
.include <bsd.port.mk>
