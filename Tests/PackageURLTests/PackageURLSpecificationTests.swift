import XCTest
import PackageURL

/**
 - Remark: These tests were translated from the test suite data file provided at
           [test-suite-data.json](https://github.com/package-url/purl-spec/blob/0b1559f76b79829e789c4f20e6d832c7314762c5/test-suite-data.json).
 */
final class PackageURLSpecificationTests: XCTestCase {
    func testValidMavenPurl() {
        let string = "pkg:maven/org.apache.commons/io@1.3.4"
        let purl = PackageURL(string)?.canonicalized
        XCTAssertNotNil(purl)
        XCTAssertEqual(purl?.type, "maven")
        XCTAssertEqual(purl?.namespace, "org.apache.commons")
        XCTAssertEqual(purl?.name, "io")
        XCTAssertEqual(purl?.version, "1.3.4")
        XCTAssertNil(purl?.qualifiers)
        XCTAssertNil(purl?.subpath)

        let canonical = "pkg:maven/org.apache.commons/io@1.3.4"
        XCTAssertEqual(purl?.description, canonical)
    }

    func testValidMavenPurlWithoutVersion() {
        let string = "pkg:maven/org.apache.commons/io"
        let purl = PackageURL(string)?.canonicalized
        XCTAssertNotNil(purl)
        XCTAssertEqual(purl?.type, "maven")
        XCTAssertEqual(purl?.namespace, "org.apache.commons")
        XCTAssertEqual(purl?.name, "io")
        XCTAssertNil(purl?.version)
        XCTAssertNil(purl?.qualifiers)
        XCTAssertNil(purl?.subpath)
        
        let canonical = "pkg:maven/org.apache.commons/io"
        XCTAssertEqual(purl?.description, canonical)
    }

    func testValidGoPurlWithoutVersionAndWithSubpath() {
        let string = "pkg:GOLANG/google.golang.org/genproto#/googleapis/api/annotations/"
        let purl = PackageURL(string)?.canonicalized
        XCTAssertNotNil(purl)
        XCTAssertEqual(purl?.type, "golang")
        XCTAssertEqual(purl?.namespace, "google.golang.org")
        XCTAssertEqual(purl?.name, "genproto")
        XCTAssertNil(purl?.version)
        XCTAssertNil(purl?.qualifiers)
        XCTAssertEqual(purl?.subpath, "googleapis/api/annotations")
        
        let canonical = "pkg:golang/google.golang.org/genproto#googleapis/api/annotations"
        XCTAssertEqual(purl?.description, canonical)
    }

    func testValidGoPurlWithVersionAndSubpath() {
        let string = "pkg:GOLANG/google.golang.org/genproto@abcdedf#/googleapis/api/annotations/"
        let purl = PackageURL(string)?.canonicalized
        XCTAssertNotNil(purl)
        XCTAssertEqual(purl?.type, "golang")
        XCTAssertEqual(purl?.namespace, "google.golang.org")
        XCTAssertEqual(purl?.name, "genproto")
        XCTAssertEqual(purl?.version, "abcdedf")
        XCTAssertNil(purl?.qualifiers)
        XCTAssertEqual(purl?.subpath, "googleapis/api/annotations")
        
        let canonical = "pkg:golang/google.golang.org/genproto@abcdedf#googleapis/api/annotations"
        XCTAssertEqual(purl?.description, canonical)
    }

    func testBitbucketNamespaceAndNameShouldBeLowercase() {
        let string = "pkg:bitbucket/birKenfeld/pyGments-main@244fd47e07d1014f0aed9c"
        let purl = PackageURL(string)?.canonicalized
        XCTAssertNotNil(purl)
        XCTAssertEqual(purl?.type, "bitbucket")
        XCTAssertEqual(purl?.namespace, "birkenfeld")
        XCTAssertEqual(purl?.name, "pygments-main")
        XCTAssertEqual(purl?.version, "244fd47e07d1014f0aed9c")
        XCTAssertNil(purl?.qualifiers)
        XCTAssertNil(purl?.subpath)

        let canonical = "pkg:bitbucket/birkenfeld/pygments-main@244fd47e07d1014f0aed9c"
        XCTAssertEqual(purl?.description, canonical)
    }

    func testGitHubNamespaceAndNameShouldBeLowercase() {
        let string = "pkg:github/Package-url/purl-Spec@244fd47e07d1004f0aed9c"
        let purl = PackageURL(string)?.canonicalized
        XCTAssertNotNil(purl)
        XCTAssertEqual(purl?.type, "github")
        XCTAssertEqual(purl?.namespace, "package-url")
        XCTAssertEqual(purl?.name, "purl-spec")
        XCTAssertEqual(purl?.version, "244fd47e07d1004f0aed9c")
        XCTAssertNil(purl?.qualifiers)
        XCTAssertNil(purl?.subpath)

        let canonical = "pkg:github/package-url/purl-spec@244fd47e07d1004f0aed9c"
        XCTAssertEqual(purl?.description, canonical)
    }

    func testDebianCanUseQualifiers() {
        let string = "pkg:deb/debian/curl@7.50.3-1?arch=i386&distro=jessie"
        let purl = PackageURL(string)?.canonicalized
        XCTAssertNotNil(purl)
        XCTAssertEqual(purl?.type, "deb")
        XCTAssertEqual(purl?.namespace, "debian")
        XCTAssertEqual(purl?.name, "curl")
        XCTAssertEqual(purl?.version, "7.50.3-1")
        XCTAssertEqual(purl?.qualifiers?.count, 2)
        XCTAssertEqual(purl?.qualifiers?["arch"], "i386")
        XCTAssertEqual(purl?.qualifiers?["distro"], "jessie")
        XCTAssertNil(purl?.subpath)

        let canonical = "pkg:deb/debian/curl@7.50.3-1?arch=i386&distro=jessie"
        XCTAssertEqual(purl?.description, canonical)
    }

    func testDockerUsesQualifiersAndHashImageIDAsVersions() {
        let string = "pkg:docker/customer/dockerimage@sha256:244fd47e07d1004f0aed9c?repository_url=gcr.io"
        let purl = PackageURL(string)?.canonicalized
        XCTAssertNotNil(purl)
        XCTAssertEqual(purl?.type, "docker")
        XCTAssertEqual(purl?.namespace, "customer")
        XCTAssertEqual(purl?.name, "dockerimage")
        XCTAssertEqual(purl?.version, "sha256:244fd47e07d1004f0aed9c")
        XCTAssertEqual(purl?.qualifiers?.count, 1)
        XCTAssertEqual(purl?.qualifiers?["repository_url"], "gcr.io")
        XCTAssertNil(purl?.subpath)

        let canonical = "pkg:docker/customer/dockerimage@sha256:244fd47e07d1004f0aed9c?repository_url=gcr.io"
        XCTAssertEqual(purl?.description, canonical)
    }

    func testJavaGemCanUseAQualifier() {
        let string = "pkg:gem/jruby-launcher@1.1.2?Platform=java"
        let purl = PackageURL(string)?.canonicalized
        XCTAssertNotNil(purl)
        XCTAssertEqual(purl?.type, "gem")
        XCTAssertNil(purl?.namespace)
        XCTAssertEqual(purl?.name, "jruby-launcher")
        XCTAssertEqual(purl?.version, "1.1.2")
        XCTAssertEqual(purl?.qualifiers?.count, 1)
        XCTAssertEqual(purl?.qualifiers?["platform"], "java")
        XCTAssertNil(purl?.subpath)

        let canonical = "pkg:gem/jruby-launcher@1.1.2?platform=java"
        XCTAssertEqual(purl?.description, canonical)
    }

    func testMavenOftenUsesQualifiers() {
        let string = "pkg:Maven/org.apache.xmlgraphics/batik-anim@1.9.1?classifier=sources&repositorY_url=repo.spring.io/release"
        let purl = PackageURL(string)?.canonicalized
        XCTAssertNotNil(purl)
        XCTAssertEqual(purl?.type, "maven")
        XCTAssertEqual(purl?.namespace, "org.apache.xmlgraphics")
        XCTAssertEqual(purl?.name, "batik-anim")
        XCTAssertEqual(purl?.version, "1.9.1")
        XCTAssertEqual(purl?.qualifiers?.count, 2)
        XCTAssertEqual(purl?.qualifiers?["classifier"], "sources")
        XCTAssertEqual(purl?.qualifiers?["repository_url"], "repo.spring.io/release")
        XCTAssertNil(purl?.subpath)

        let canonical = "pkg:maven/org.apache.xmlgraphics/batik-anim@1.9.1?classifier=sources&repository_url=repo.spring.io/release"
        XCTAssertEqual(purl?.description, canonical)
    }

    func testMavenPOMReference() {
        let string = "pkg:Maven/org.apache.xmlgraphics/batik-anim@1.9.1?extension=pom&repositorY_url=repo.spring.io/release"
        let purl = PackageURL(string)?.canonicalized
        XCTAssertNotNil(purl)
        XCTAssertEqual(purl?.type, "maven")
        XCTAssertEqual(purl?.namespace, "org.apache.xmlgraphics")
        XCTAssertEqual(purl?.name, "batik-anim")
        XCTAssertEqual(purl?.version, "1.9.1")
        XCTAssertEqual(purl?.qualifiers?.count, 2)
        XCTAssertEqual(purl?.qualifiers?["extension"], "pom")
        XCTAssertEqual(purl?.qualifiers?["repository_url"], "repo.spring.io/release")
        XCTAssertNil(purl?.subpath)

        let canonical = "pkg:maven/org.apache.xmlgraphics/batik-anim@1.9.1?extension=pom&repository_url=repo.spring.io/release"
        XCTAssertEqual(purl?.description, canonical)
    }

    func testMavenCanComeWithATypeQualifier() {
        let string = "pkg:Maven/net.sf.jacob-project/jacob@1.14.3?classifier=x86&type=dll"
        let purl = PackageURL(string)?.canonicalized
        XCTAssertNotNil(purl)
        XCTAssertEqual(purl?.type, "maven")
        XCTAssertEqual(purl?.namespace, "net.sf.jacob-project")
        XCTAssertEqual(purl?.name, "jacob")
        XCTAssertEqual(purl?.version, "1.14.3")
        XCTAssertEqual(purl?.qualifiers?.count, 2)
        XCTAssertEqual(purl?.qualifiers?["classifier"], "x86")
        XCTAssertEqual(purl?.qualifiers?["type"], "dll")
        XCTAssertNil(purl?.subpath)

        let canonical = "pkg:maven/net.sf.jacob-project/jacob@1.14.3?classifier=x86&type=dll"
        XCTAssertEqual(purl?.description, canonical)
    }

    func testNPMCanBeScoped() {
        let string = "pkg:npm/%40angular/animation@12.3.1"
        let purl = PackageURL(string)?.canonicalized
        XCTAssertNotNil(purl)
        XCTAssertEqual(purl?.type, "npm")
        XCTAssertEqual(purl?.namespace, "@angular")
        XCTAssertEqual(purl?.name, "animation")
        XCTAssertEqual(purl?.version, "12.3.1")
        XCTAssertNil(purl?.qualifiers)
        XCTAssertNil(purl?.subpath)

        let canonical = "pkg:npm/%40angular/animation@12.3.1"
        XCTAssertEqual(purl?.description, canonical)
    }

    func testNuGetNamesAreCaseSensitive() {
        let string = "pkg:Nuget/EnterpriseLibrary.Common@6.0.1304"
        let purl = PackageURL(string)?.canonicalized
        XCTAssertNotNil(purl)
        XCTAssertEqual(purl?.type, "nuget")
        XCTAssertNil(purl?.namespace)
        XCTAssertEqual(purl?.name, "EnterpriseLibrary.Common")
        XCTAssertEqual(purl?.version, "6.0.1304")
        XCTAssertNil(purl?.qualifiers)
        XCTAssertNil(purl?.subpath)

        let canonical = "pkg:nuget/EnterpriseLibrary.Common@6.0.1304"
        XCTAssertEqual(purl?.description, canonical)
    }

    func testPyPINamesHaveSpecialRulesAndAreCaseInsensitive() {
        let string = "pkg:PYPI/Django_package@1.11.1.dev1"
        let purl = PackageURL(string)?.canonicalized
        XCTAssertNotNil(purl)
        XCTAssertEqual(purl?.type, "pypi")
        XCTAssertNil(purl?.namespace)
        XCTAssertEqual(purl?.name, "django-package")
        XCTAssertEqual(purl?.version, "1.11.1.dev1")
        XCTAssertNil(purl?.qualifiers)
        XCTAssertNil(purl?.subpath)

        let canonical = "pkg:pypi/django-package@1.11.1.dev1"
        XCTAssertEqual(purl?.description, canonical)
    }

    func testRPMOftenUseQualifiers() {
        let string = "pkg:Rpm/fedora/curl@7.50.3-1.fc25?Arch=i386&Distro=fedora-25"
        let purl = PackageURL(string)?.canonicalized
        XCTAssertNotNil(purl)
        XCTAssertEqual(purl?.type, "rpm")
        XCTAssertEqual(purl?.namespace, "fedora")
        XCTAssertEqual(purl?.name, "curl")
        XCTAssertEqual(purl?.version, "7.50.3-1.fc25")
        XCTAssertEqual(purl?.qualifiers?.count, 2)
        XCTAssertEqual(purl?.qualifiers?["arch"], "i386")
        XCTAssertEqual(purl?.qualifiers?["distro"], "fedora-25")
        XCTAssertNil(purl?.subpath)

        let canonical = "pkg:rpm/fedora/curl@7.50.3-1.fc25?arch=i386&distro=fedora-25"
        XCTAssertEqual(purl?.description, canonical)
    }

    func testASchemeIsRequired() {
        let string = "EnterpriseLibrary.Common@6.0.1304"
        let purl = PackageURL(string)?.canonicalized
        XCTAssertNil(purl)
    }

    func testATypeIsRequired() {
        let string = "pkg:EnterpriseLibrary.Common@6.0.1304"
        let purl = PackageURL(string)?.canonicalized
        XCTAssertNil(purl)
    }

    func testANameIsRequired() {
        let string = "pkg:maven/@1.3.4"
        let purl = PackageURL(string)?.canonicalized
        XCTAssertNil(purl)
    }

    func testSlashAfterSchemeIsNotSignificant() {
        let string = "pkg:/maven/org.apache.commons/io"
        let purl = PackageURL(string)?.canonicalized
        XCTAssertNotNil(purl)
        XCTAssertEqual(purl?.type, "maven")
        XCTAssertEqual(purl?.namespace, "org.apache.commons")
        XCTAssertEqual(purl?.name, "io")
        XCTAssertNil(purl?.version)
        XCTAssertNil(purl?.qualifiers)
        XCTAssertNil(purl?.subpath)

        let canonical = "pkg:maven/org.apache.commons/io"
        XCTAssertEqual(purl?.description, canonical)
    }

    func testDoubleSlashAfterSchemeIsNotSignificant() {
        let string = "pkg://maven/org.apache.commons/io"
        let purl = PackageURL(string)?.canonicalized
        XCTAssertNotNil(purl)
        XCTAssertEqual(purl?.type, "maven")
        XCTAssertEqual(purl?.namespace, "org.apache.commons")
        XCTAssertEqual(purl?.name, "io")
        XCTAssertNil(purl?.version)
        XCTAssertNil(purl?.qualifiers)
        XCTAssertNil(purl?.subpath)

        let canonical = "pkg:maven/org.apache.commons/io"
        XCTAssertEqual(purl?.description, canonical)
    }

    func testSlashAfterTypeWithDoubleSlashAfterSchemeIsNotSignificant() {
        let string = "pkg:///maven/org.apache.commons/io"
        let purl = PackageURL(string)?.canonicalized
        XCTAssertNotNil(purl)
        XCTAssertEqual(purl?.type, "maven")
        XCTAssertEqual(purl?.namespace, "org.apache.commons")
        XCTAssertEqual(purl?.name, "io")
        XCTAssertNil(purl?.version)
        XCTAssertNil(purl?.qualifiers)
        XCTAssertNil(purl?.subpath)

        let canonical = "pkg:maven/org.apache.commons/io"
        XCTAssertEqual(purl?.description, canonical)
    }

    func testValidMavenPurlWithCaseSensitiveNamespaceAndName() {
        let string = "pkg:maven/HTTPClient/HTTPClient@0.3-3"
        let purl = PackageURL(string)?.canonicalized
        XCTAssertNotNil(purl)
        XCTAssertEqual(purl?.type, "maven")
        XCTAssertEqual(purl?.namespace, "HTTPClient")
        XCTAssertEqual(purl?.name, "HTTPClient")
        XCTAssertEqual(purl?.version, "0.3-3")
        XCTAssertNil(purl?.qualifiers)
        XCTAssertNil(purl?.subpath)

        let canonical = "pkg:maven/HTTPClient/HTTPClient@0.3-3"
        XCTAssertEqual(purl?.description, canonical)
    }

    func testValidMavenPurlContainingASpaceInTheVersionAndQualifiers() {
        let string = "pkg:maven/mygroup/myartifact@1.0.0%20Final?mykey=my%20value"
        let purl = PackageURL(string)?.canonicalized
        XCTAssertNotNil(purl)
        XCTAssertEqual(purl?.type, "maven")
        XCTAssertEqual(purl?.namespace, "mygroup")
        XCTAssertEqual(purl?.name, "myartifact")
        XCTAssertEqual(purl?.version, "1.0.0 Final")
        XCTAssertEqual(purl?.qualifiers?.count, 1)
        XCTAssertEqual(purl?.qualifiers?["mykey"], "my value")
        XCTAssertNil(purl?.subpath)

        let canonical = "pkg:maven/mygroup/myartifact@1.0.0%20Final?mykey=my%20value"
        XCTAssertEqual(purl?.description, canonical)
    }

    func testChecksForInvalidQualifierKeys() {
        let string = "pkg:npm/myartifact@1.0.0?in%20production=true"
        let purl = PackageURL(string)?.canonicalized
        XCTAssertNil(purl)
    }
}
