import Foundation
import Network

public class Socket {
    
    let connection: NWConnection
    
    init(hostName: String, port: Int) {
        
        //        jose: tcpOptions and parames are optionals, in these case they are used to configure  a timeout
        
        var tcpOptions: NWProtocolTCP.Options = {
            let options = NWProtocolTCP.Options()
            options.connectionTimeout = 20 // connection timed out
            return options
        }()
        
        var parames: NWParameters = {
            let parames = NWParameters(tls: nil, tcp: tcpOptions)
            if let isOption = parames.defaultProtocolStack.internetProtocol as? NWProtocolIP.Options {
                isOption.version = .v4
            }
            parames.preferNoProxies = true
            return parames
        }()
        
        
        
        let host = NWEndpoint.Host(hostName)
        let port = NWEndpoint.Port("\(port)")!
        //        self.connection = NWConnection(host: host, port: port, using: .tcp) //When you dont use a parameters with timeout
        self.connection = NWConnection(host: host, port: port, using: parames)

        
    }
    
    
    
    func start() {
        print("Will start")
        self.connection.stateUpdateHandler = self.didChange(state:)
        self.startReceive()
        self.connection.start(queue: .global(qos: .background))
    }
    
    func stop() {
        self.connection.cancel()
        print("Did stop")
    }
    
    private func didChange(state: NWConnection.State) {
        switch state {
        case .setup:
            print("SetUp")
            break
        case .waiting(let error):
            print("Is waiting: ", "\(error)")
            break
        case .preparing:
            print("Preparing")
            break
        case .ready:
            print("Ready")
            break
        case .failed(let error):
            print("Did fail, error: %@", "\(error)")
            self.stop()
        case .cancelled:
            print("Was cancelled")
            self.stop()
            print("Stop")
        @unknown default:
            break
        }
    }
    
    private func startReceive() {
        self.connection.receive(minimumIncompleteLength: 1, maximumLength: 65536) { data, _, isDone, error in
            if let data = data, !data.isEmpty {
                let messagesServer = String(data: data, encoding: .utf8)!.split(separator: "\n")
                //                print("Data received: ", messagesServer)
                for message in messagesServer{
                    print("Received: \(message)")
                    //                Check if data received is a turn
                    if(message.contains("id")){
                        do{
                            struct Objeto: Decodable{
                                var department: String
                                var id: String
                            }
                            var jsonData = data
                            var objeto: Objeto = try JSONDecoder().decode(Objeto.self, from: data)
                            self.sendNotification(message: objeto.id)
                            
                        }
                        catch{
                            print("Error parsing json response")
                        }
                        
                    }
                }
                
                
            }
            if let error = error {
                print("Did receive, error: ", "\(error)")
                self.stop()
                return
            }
            if isDone {
                print("Did receive, EOF")
                self.stop()
                return
            }
            self.startReceive()
        }
    }
    
    func send(line: String) {
        let data = Data("\(line)\r\n".utf8)
        self.connection.send(content: data, completion: NWConnection.SendCompletion.contentProcessed { error in
            if let error = error {
                print("Did send, error: ", "\(error)")
                self.stop()
            } else {
                print("Did send, data: ", line)
            }
        })
    }
    
    func sendNotification(message: String){
        NotificationCenter.default.post(name: .socketNotification, object: nil, userInfo: [ "value" : message, ])
    }
    //    This is a example that home shedule a task in swift
    //    This is a example that home shedule a task in swift
    //    This is a example that home shedule a task in swift
    
    //    public static func run() -> Never {
    //        let m = Socket2(hostName: "127.0.0.1", port: 8001)
    //        m.start()
    //
    //        let t = DispatchSource.makeTimerSource(queue: .global(qos: .background))
    //        var counter = 99
    //        t.setEventHandler {
    //            m.send(line: "\(counter) bottles of beer on the wall.")
    //            counter -= 1
    //            if counter == 0 {
    //                m.stop()
    //                exit(EXIT_SUCCESS)
    //            }
    //        }
    //        t.schedule(wallDeadline: .now() + 1.0, repeating: 1.0)
    //        t.activate()
    //
    //        dispatchMain()
    //    }
    
    
    //    public static func run(){
    //        let m = Socket2(hostName: "127.0.0.12", port: 8001)
    //        m.start()
    //        m.send(line: "I`m a iPhone")
    //
    //
    //    }
    
}


