import XCTest
import PackageURL

/**
 - Remark: These tests were translated from the test suite data file provided at
           [README.rst](https://github.com/package-url/purl-spec/blob/0b1559f76b79829e789c4f20e6d832c7314762c5/README.rst#some-purl-examples).
 */
final class PackageURLExampleTests: XCTestCase {
    func testBitbucketExample() {
        let string = "pkg:bitbucket/birkenfeld/pygments-main@244fd47e07d1014f0aed9c"
        let purl = PackageURL(string)
        XCTAssertNotNil(purl)
        XCTAssertEqual(purl?.scheme, "pkg")
        XCTAssertEqual(purl?.type, "bitbucket")
        XCTAssertEqual(purl?.namespace, "birkenfeld")
        XCTAssertEqual(purl?.name, "pygments-main")
        XCTAssertEqual(purl?.version, "244fd47e07d1014f0aed9c")
        XCTAssertNil(purl?.subpath)
        XCTAssertNil(purl?.qualifiers)
        XCTAssertEqual(purl?.description, string)
    }

    func testRubygemsExample() {
        let string = "pkg:gem/ruby-advisory-db-check@0.12.4"
        let purl = PackageURL(string)
        XCTAssertNotNil(purl)
        XCTAssertEqual(purl?.scheme, "pkg")
        XCTAssertEqual(purl?.type, "gem")
        XCTAssertNil(purl?.namespace)
        XCTAssertEqual(purl?.name, "ruby-advisory-db-check")
        XCTAssertEqual(purl?.version, "0.12.4")
        XCTAssertNil(purl?.subpath)
        XCTAssertNil(purl?.qualifiers)
        XCTAssertEqual(purl?.description, string)
    }

    func testGithubExample() {
        let string = "pkg:github/package-url/purl-spec@244fd47e07d1004f0aed9c"
        let purl = PackageURL(string)
        XCTAssertNotNil(purl)
        XCTAssertEqual(purl?.scheme, "pkg")
        XCTAssertEqual(purl?.type, "github")
        XCTAssertEqual(purl?.namespace, "package-url")
        XCTAssertEqual(purl?.name, "purl-spec")
        XCTAssertEqual(purl?.version, "244fd47e07d1004f0aed9c")
        XCTAssertNil(purl?.subpath)
        XCTAssertNil(purl?.qualifiers)
        XCTAssertEqual(purl?.description, string)
    }

    func testGoExample() {
        let string = "pkg:golang/google.golang.org/genproto#googleapis/api/annotations"
        let purl = PackageURL(string)
        XCTAssertNotNil(purl)
        XCTAssertEqual(purl?.scheme, "pkg")
        XCTAssertEqual(purl?.type, "golang")
        XCTAssertEqual(purl?.namespace, "google.golang.org")
        XCTAssertEqual(purl?.name, "genproto")
        XCTAssertNil(purl?.version)
        XCTAssertEqual(purl?.subpath, "googleapis/api/annotations")
        XCTAssertNil(purl?.qualifiers)
        XCTAssertEqual(purl?.description, string)
    }

    func testMavenExample() {
        let string = "pkg:maven/org.apache.xmlgraphics/batik-anim@1.9.1?packaging=sources"
        let purl = PackageURL(string)
        XCTAssertNotNil(purl)
        XCTAssertEqual(purl?.scheme, "pkg")
        XCTAssertEqual(purl?.type, "maven")
        XCTAssertEqual(purl?.namespace, "org.apache.xmlgraphics")
        XCTAssertEqual(purl?.name, "batik-anim")
        XCTAssertEqual(purl?.version, "1.9.1")
        XCTAssertNil(purl?.subpath)
        XCTAssertEqual(purl?.qualifiers?.count, 1)
        XCTAssertEqual(purl?.qualifiers?.first?.key, "packaging")
        XCTAssertEqual(purl?.qualifiers?.first?.value, "sources")
        XCTAssertEqual(purl?.description, string)
    }

    func testNPMExample() {
        let string = "pkg:npm/foobar@12.3.1"
        let purl = PackageURL(string)
        XCTAssertNotNil(purl)
        XCTAssertEqual(purl?.scheme, "pkg")
        XCTAssertEqual(purl?.type, "npm")
        XCTAssertNil(purl?.namespace)
        XCTAssertEqual(purl?.name, "foobar")
        XCTAssertEqual(purl?.version, "12.3.1")
        XCTAssertNil(purl?.subpath)
        XCTAssertNil(purl?.qualifiers)
        XCTAssertEqual(purl?.description, string)
    }

    func testNuGetExample() {
        let string = "pkg:nuget/EnterpriseLibrary.Common@6.0.1304"
        let purl = PackageURL(string)
        XCTAssertNotNil(purl)
        XCTAssertEqual(purl?.scheme, "pkg")
        XCTAssertEqual(purl?.type, "nuget")
        XCTAssertNil(purl?.namespace)
        XCTAssertEqual(purl?.name, "EnterpriseLibrary.Common")
        XCTAssertEqual(purl?.version, "6.0.1304")
        XCTAssertNil(purl?.subpath)
        XCTAssertNil(purl?.qualifiers)
        XCTAssertEqual(purl?.description, string)
    }

    func testPyPIExample() {
        let string = "pkg:pypi/django@1.11.1"
        let purl = PackageURL(string)
        XCTAssertNotNil(purl)
        XCTAssertEqual(purl?.scheme, "pkg")
        XCTAssertEqual(purl?.type, "pypi")
        XCTAssertNil(purl?.namespace)
        XCTAssertEqual(purl?.name, "django")
        XCTAssertEqual(purl?.version, "1.11.1")
        XCTAssertNil(purl?.subpath)
        XCTAssertNil(purl?.qualifiers)
        XCTAssertEqual(purl?.description, string)
    }

    func testRPMExample() {
        let string = "pkg:rpm/fedora/curl@7.50.3-1.fc25?arch=i386&distro=fedora-25"
        let purl = PackageURL(string)
        XCTAssertNotNil(purl)
        XCTAssertEqual(purl?.scheme, "pkg")
        XCTAssertEqual(purl?.type, "rpm")
        XCTAssertEqual(purl?.namespace, "fedora")
        XCTAssertEqual(purl?.name, "curl")
        XCTAssertEqual(purl?.version, "7.50.3-1.fc25")
        XCTAssertNil(purl?.subpath)
        XCTAssertEqual(purl?.qualifiers?.count, 2)
        XCTAssertEqual(purl?.qualifiers?["arch"], "i386")
        XCTAssertEqual(purl?.qualifiers?["distro"], "fedora-25")
        XCTAssertEqual(purl?.description, string)
    }

    func testSwiftExample() {
        let string = "pkg:swift/apple/swift-argument-parser@0.4.3"
        let purl = PackageURL(string)
        XCTAssertNotNil(purl)
        XCTAssertEqual(purl?.scheme, "pkg")
        XCTAssertEqual(purl?.type, "swift")
        XCTAssertEqual(purl?.namespace, "apple")
        XCTAssertEqual(purl?.name, "swift-argument-parser")
        XCTAssertEqual(purl?.version, "0.4.3")
        XCTAssertNil(purl?.subpath)
        XCTAssertNil(purl?.qualifiers)
        XCTAssertEqual(purl?.description, string)
    }
}
