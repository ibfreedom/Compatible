//
//  UserDefaults+Hub.swift
//  Compatible
//
//  Created by tramp on 2021/4/1.
//

import Foundation

// MARK: - Uniqueable
/// Uniqueable
public protocol Uniqueable {
    /// unique identififer
    var uniqueID: String { get }
}

extension String: Uniqueable {
    /// String
    public var uniqueID: String {
        return self
    }
}

// MARK: - UserDefaults.Key
extension UserDefaults {
    
    /// userdefaults key struct
    public struct Key {
        /// raw value
        internal let rawValue: String
        /// lock
        internal let lock: NSLock
        
        /// 构建
        /// - Parameter rawValue: String
        public init(rawValue: String) {
            self.rawValue = rawValue
            self.lock = .init()
        }
    }
}

extension UserDefaults.Key {
    
    /// safe execute block
    /// - Parameter block: ()-> Void
    internal func safe(_ block: @escaping ()->Void) {
        lock.hub.execute(block)
    }
    
    /// safe execute block
    /// - Parameter block: ()->T
    /// - Returns: T
    internal func safe<T>(_ block: @escaping ()->T) -> T {
        return lock.hub.execute(block)
    }
}


/// UserDefaults
extension UserDefaults {
    
    /// [AnyHashable: UserDefaults]
    private static var map: [AnyHashable: UserDefaults] = [:]
    /// NSLock
    private static let lock: NSLock = .init()
    
    /// get shared object for uniqueable
    /// - Parameter unique: Uniqueable
    /// - Returns: UserDefaults
    @discardableResult
    public static func shared(of unique: Uniqueable) -> UserDefaults {
        let mapkey = unique.uniqueID.hub.md5()
        return lock.hub.execute { () -> UserDefaults in
            if let value = map[mapkey] {
                return value
            } else {
                if let object = UserDefaults.init(suiteName: mapkey) {
                    map[mapkey] = object
                    return object
                } else {
                    let object = UserDefaults.init()
                    object.addSuite(named: mapkey)
                    map[mapkey] = object
                    return object
                }
                
            }
        }
    }
}

extension UserDefaults: Compatible {}
extension CompatibleWapper where Base: UserDefaults {
    /**
     -objectForKey: will search the receiver's search list for a default with the key 'defaultKey' and return it. If another process has changed defaults in the search list, NSUserDefaults will automatically update to the latest values. If the key in question has been marked as ubiquitous via a Defaults Configuration File, the latest value may not be immediately available, and the registered value will be returned instead.
     */
    public func object(forKey defaultKey: UserDefaults.Key) -> Any? {
        return defaultKey.safe {
            return base.object(forKey: defaultKey.rawValue)
        }
    }
    
    /**
     -setObject:forKey: immediately stores a value (or removes the value if nil is passed as the value) for the provided key in the search list entry for the receiver's suite name in the current user and any host, then asynchronously stores the value persistently, where it is made available to other processes.
     */
    @discardableResult
    public func set(_ value: Any?, forKey defaultKey: UserDefaults.Key) -> Base {
        return defaultKey.safe {
            base.set(value, forKey: defaultKey.rawValue)
            return base
        }
    }
    
    /// -removeObjectForKey: is equivalent to -[... setObject:nil forKey:defaultKey]
    @discardableResult
    public func removeObject(forKey defaultKey: UserDefaults.Key) -> Base {
        return defaultKey.safe {
            base.removeObject(forKey: defaultKey.rawValue)
            return base
        }
    }
    
    /// -stringForKey: is equivalent to -objectForKey:, except that it will convert NSNumber values to their NSString representation. If a non-string non-number value is found, nil will be returned.
    public func string(forKey defaultKey: UserDefaults.Key) -> String? {
        return defaultKey.safe {
            return base.string(forKey: defaultKey.rawValue)
        }
    }
    
    /// -arrayForKey: is equivalent to -objectForKey:, except that it will return nil if the value is not an NSArray.
    public func array(forKey defaultKey: UserDefaults.Key) -> [Any]? {
        return defaultKey.safe {
            return base.array(forKey: defaultKey.rawValue)
        }
    }
    
    /// -dictionaryForKey: is equivalent to -objectForKey:, except that it will return nil if the value is not an NSDictionary.
    public func dictionary(forKey defaultKey: UserDefaults.Key) -> [String : Any]? {
        return defaultKey.safe {
            return base.dictionary(forKey: defaultKey.rawValue)
        }
    }
    
    /// -dataForKey: is equivalent to -objectForKey:, except that it will return nil if the value is not an NSData.
    public func data(forKey defaultKey: UserDefaults.Key) -> Data? {
        return defaultKey.safe {
            return base.data(forKey: defaultKey.rawValue)
        }
    }
    
    /// -stringForKey: is equivalent to -objectForKey:, except that it will return nil if the value is not an NSArray<NSString *>. Note that unlike -stringForKey:, NSNumbers are not converted to NSStrings.
    public func stringArray(forKey defaultKey: UserDefaults.Key) -> [String]? {
        return defaultKey.safe {
            return base.stringArray(forKey: defaultKey.rawValue)
        }
    }
    
    /**
     -integerForKey: is equivalent to -objectForKey:, except that it converts the returned value to an NSInteger. If the value is an NSNumber, the result of -integerValue will be returned. If the value is an NSString, it will be converted to NSInteger if possible. If the value is a boolean, it will be converted to either 1 for YES or 0 for NO. If the value is absent or can't be converted to an integer, 0 will be returned.
     */
    public func integer(forKey defaultKey: UserDefaults.Key) -> Int {
        return defaultKey.safe {
            return base.integer(forKey: defaultKey.rawValue)
        }
    }
    
    /// -floatForKey: is similar to -integerForKey:, except that it returns a float, and boolean values will not be converted.
    public func float(forKey defaultKey: UserDefaults.Key) -> Float {
        return defaultKey.safe {
            return base.float(forKey: defaultKey.rawValue)
        }
    }
    
    /// -doubleForKey: is similar to -integerForKey:, except that it returns a double, and boolean values will not be converted.
    public func double(forKey defaultKey: UserDefaults.Key) -> Double {
        return defaultKey.safe {
            return base.double(forKey: defaultKey.rawValue)
        }
    }
    
    /**
     -boolForKey: is equivalent to -objectForKey:, except that it converts the returned value to a BOOL. If the value is an NSNumber, NO will be returned if the value is 0, YES otherwise. If the value is an NSString, values of "YES" or "1" will return YES, and values of "NO", "0", or any other string will return NO. If the value is absent or can't be converted to a BOOL, NO will be returned.
     
     */
    public func bool(forKey defaultKey: UserDefaults.Key) -> Bool {
        return defaultKey.safe {
            return base.bool(forKey: defaultKey.rawValue)
        }
    }
    
    /**
     -URLForKey: is equivalent to -objectForKey: except that it converts the returned value to an NSURL. If the value is an NSString path, then it will construct a file URL to that path. If the value is an archived URL from -setURL:forKey: it will be unarchived. If the value is absent or can't be converted to an NSURL, nil will be returned.
     */
    @available(iOS 4.0, *)
    public func url(forKey defaultKey: UserDefaults.Key) -> URL? {
        return defaultKey.safe {
            return base.url(forKey: defaultKey.rawValue)
        }
    }
    
    /// -setInteger:forKey: is equivalent to -setObject:forKey: except that the value is converted from an NSInteger to an NSNumber.
    @discardableResult
    public func set(_ value: Int, forKey defaultKey: UserDefaults.Key) -> Base {
        return defaultKey.safe {
            base.set(value, forKey: defaultKey.rawValue)
            return base
        }
    }
    
    /// -setFloat:forKey: is equivalent to -setObject:forKey: except that the value is converted from a float to an NSNumber.
    @discardableResult
    public func set(_ value: Float, forKey defaultKey: UserDefaults.Key) -> Base {
        return defaultKey.safe {
            base.set(value, forKey: defaultKey.rawValue)
            return base
        }
    }
    
    /// -setDouble:forKey: is equivalent to -setObject:forKey: except that the value is converted from a double to an NSNumber.
    @discardableResult
    public func set(_ value: Double, forKey defaultKey: UserDefaults.Key) -> Base {
        return defaultKey.safe {
            base.set(value, forKey: defaultKey.rawValue)
            return base
        }
    }
    
    /// -setBool:forKey: is equivalent to -setObject:forKey: except that the value is converted from a BOOL to an NSNumber.
    @discardableResult
    public func set(_ value: Bool, forKey defaultKey: UserDefaults.Key) -> Base {
        return defaultKey.safe {
            base.set(value, forKey: defaultKey.rawValue)
            return base
        }
    }
    
    /// -setURL:forKey is equivalent to -setObject:forKey: except that the value is archived to an NSData. Use -URLForKey: to retrieve values set this way.
    @available(iOS 4.0, *) @discardableResult
    public func set(_ url: URL?, forKey defaultKey: UserDefaults.Key) -> Base {
        return defaultKey.safe {
            base.set(url, forKey: defaultKey.rawValue)
            return base
        }
    }
    
    /**
     -registerDefaults: adds the registrationDictionary to the last item in every search list. This means that after NSUserDefaults has looked for a value in every other valid location, it will look in registered defaults, making them useful as a "fallback" value. Registered defaults are never stored between runs of an application, and are visible only to the application that registers them.
     
     Default values from Defaults Configuration Files will automatically be registered.
     */
    @discardableResult
    public func register(defaults registrationDictionary: [String : Any]) -> Base {
        base.register(defaults: registrationDictionary)
        return base
    }
    
    /**
     -addSuiteNamed: adds the full search list for 'suiteName' as a sub-search-list of the receiver's. The additional search lists are searched after the current domain, but before global defaults. Passing NSGlobalDomain or the current application's bundle identifier is unsupported.
     */
    @discardableResult
    public func addSuite(named suiteName: String) -> Base {
        base.addSuite(named: suiteName)
        return base
    }
    
    /**
     -removeSuiteNamed: removes a sub-searchlist added via -addSuiteNamed:.
     */
    @discardableResult
    public func removeSuite(named suiteName: String) -> Base {
        base.removeSuite(named: suiteName)
        return base
    }
    
    /**
     -dictionaryRepresentation returns a composite snapshot of the values in the receiver's search list, such that [[receiver dictionaryRepresentation] objectForKey:x] will return the same thing as [receiver objectForKey:x].
     */
    public func dictionaryRepresentation() -> [String : Any] {
        return base.dictionaryRepresentation()
    }
    
    public var volatileDomainNames: [String] {
        return base.volatileDomainNames
    }
    
    public func volatileDomain(forName domainName: String) -> [String : Any] {
        return base.volatileDomain(forName: domainName)
    }
    
    public func setVolatileDomain(_ domain: [String : Any], forName domainName: String) {
        return base.setVolatileDomain(domain, forName: domainName)
    }
    
    @discardableResult
    public func removeVolatileDomain(forName domainName: String) -> Base {
        base.removeVolatileDomain(forName: domainName)
        return base
    }
    
    /// -persistentDomainForName: returns a dictionary representation of the search list entry specified by 'domainName', the current user, and any host.
    public func persistentDomain(forName domainName: String) -> [String : Any]? {
        return base.persistentDomain(forName: domainName)
    }
    
    /// -setPersistentDomain:forName: replaces all values in the search list entry specified by 'domainName', the current user, and any host, with the values in 'domain'. The change will be persisted.
    @discardableResult
    public func setPersistentDomain(_ domain: [String : Any], forName domainName: String) -> Base {
        base.setPersistentDomain(domain, forName: domainName)
        return base
    }
    
    /// -removePersistentDomainForName: removes all values from the search list entry specified by 'domainName', the current user, and any host. The change is persistent.
    public func removePersistentDomain(forName domainName: String) -> Base {
        base.removePersistentDomain(forName: domainName)
        return base
    }
    
    /**
     -synchronize is deprecated and will be marked with the API_DEPRECATED macro in a future release.
     
     -synchronize blocks the calling thread until all in-progress set operations have completed. This is no longer necessary. Replacements for previous uses of -synchronize depend on what the intent of calling synchronize was. If you synchronized...
     - ...before reading in order to fetch updated values: remove the synchronize call
     - ...after writing in order to notify another program to read: the other program can use KVO to observe the default without needing to notify
     - ...before exiting in a non-app (command line tool, agent, or daemon) process: call CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication)
     - ...for any other reason: remove the synchronize call
     */
    @discardableResult
    public func synchronize() -> Bool {
        base.synchronize()
    }
    
}

extension CompatibleWapper where Base: UserDefaults {
    
    /// object for key
    /// - Parameter defaultKey: UserDefaults.Key
    /// - Returns: T
    public func object<T>(for defaultKey: UserDefaults.Key) -> T? {
        return object(forKey: defaultKey) as? T
    }
    
    /// set value for key
    /// - Parameters:
    ///   - value: T
    ///   - defaultKey: UserDefaults.Key
    /// - Returns: Base
    @discardableResult
    public func set<T: Codable>(_ value: T?, for defaultKey: UserDefaults.Key) -> Base {
        if let value = value, let data = try? JSONEncoder.init().encode(value) {
            return set(data, forKey: defaultKey)
        } else {
            return set(nil, forKey: defaultKey)
        }
    }
    
    /// object for key
    /// - Parameter defaultKey: UserDefaults.Key
    /// - Returns: T?
    public func object<T: Codable>(for defaultKey: UserDefaults.Key) -> T? {
        guard let data = object(forKey: defaultKey) as? Data else { return nil }
        return try? JSONDecoder.init().decode(T.self, from: data)
    }
    
    /**
     -integerForKey: is equivalent to -objectForKey:, except that it converts the returned value to an NSInteger. If the value is an NSNumber, the result of -integerValue will be returned. If the value is an NSString, it will be converted to NSInteger if possible. If the value is a boolean, it will be converted to either 1 for YES or 0 for NO. If the value is absent or can't be converted to an integer, 0 will be returned.
     */
    public func integer(forKey defaultKey: UserDefaults.Key) -> Int? {
        return defaultKey.safe {
            return base.object(forKey: defaultKey.rawValue) as? Int
        }
    }
    
    /// -floatForKey: is similar to -integerForKey:, except that it returns a float, and boolean values will not be converted.
    public func float(forKey defaultKey: UserDefaults.Key) -> Float? {
        return defaultKey.safe {
            return base.object(forKey: defaultKey.rawValue) as? Float
        }
    }
    
    /// -doubleForKey: is similar to -integerForKey:, except that it returns a double, and boolean values will not be converted.
    public func double(forKey defaultKey: UserDefaults.Key) -> Double? {
        return defaultKey.safe {
            return base.object(forKey: defaultKey.rawValue) as? Double
        }
    }
    
    /**
     -boolForKey: is equivalent to -objectForKey:, except that it converts the returned value to a BOOL. If the value is an NSNumber, NO will be returned if the value is 0, YES otherwise. If the value is an NSString, values of "YES" or "1" will return YES, and values of "NO", "0", or any other string will return NO. If the value is absent or can't be converted to a BOOL, NO will be returned.
     
     */
    public func bool(forKey defaultKey: UserDefaults.Key) -> Bool? {
        return defaultKey.safe {
            return base.object(forKey: defaultKey.rawValue) as? Bool
        }
    }
    
    /// Date from UserDefaults.
    ///
    /// - Parameter key: key to find date for.
    /// - Returns: Date object for key (if exists).
    public func date(forKey defaultKey: UserDefaults.Key) -> Date? {
        return defaultKey.safe {
            return base.object(forKey: defaultKey.rawValue) as? Date
        }
    }
}
