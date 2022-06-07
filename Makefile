PORTNAME=	dbeaver
DISTVERSION=	g20220531
CATEGORIES=	databases
PKGNAMESUFFIX=	-dev
DISTNAME=	${PORTNAME}-${GH_TAGNAME}
DIST_SUBDIR=	${PORTNAME}${PKGNAMESUFFIX}

MAINTAINER=	nope@nothere
COMMENT=	Free universal database tool and SQL client

LICENSE=	APACHE20

BUILD_DEPENDS=  mvn:devel/maven

USES=           desktop-file-utils

USE_JAVA=	yes
JAVA_VERSION=	11
USE_GITHUB=     nodefault
GH_ACCOUNT=     dbeaver
GH_PROJECT=     dbeaver
GH_TAGNAME=	5442d6d2690f2511131f394d8d060772475963c0

WRKSRC=	${WRKDIR}/${PORTNAME}-${GH_TAGNAME}

# do- tasks found and modified from cad/digital on 20220605
do-build:
	@cd ${WRKSRC} && ${SETENV} ${MAKE_ENV} \
		${LOCALBASE}/bin/mvn ${MVN_ARGS} \
		-fae install \
		-Dmaven.deploy.skip=true \
		-D=tycho.p2.transport=ecf
#		package
#		-Duser.home=${WRKSRC} \
# if the commad ended with the tycho line it succeeded except install?
# Binaries are in product/community/target/products
# databases/dbeaver/work/dbeaver-5442d6d2690f2511131f394d8d060772475963c0/product/community/target/products/org.jkiss.dbeaver.core.product/linux/gtk/x86_64/dbeaver
#do-install:
	# install jar
	${INSTALL_DATA} ${WRKSRC}/target/Digital.jar ${STAGEDIR}${JAVAJARDIR}
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
