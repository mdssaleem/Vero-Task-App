//
//  QRScannerViewController.swift
//  VeroTaskApp
//
//  Created by MOHD SALEEM on 30/05/24.
//

import UIKit
import AVFoundation

protocol searchTextDelegate: AnyObject {
    func setTextFromQRScanner(text: String)
}

class QRScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    var qrCodeFrameView: UIView?
    var scanningSquare: UIView!
    weak var delegate: searchTextDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        captureSession = AVCaptureSession()
        
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else {
            print("Your device does not support scanning a code from an item. Use a device with a camera.")
            return
        }
        
        let videoInput: AVCaptureDeviceInput
        
        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            print("Error: \(error.localizedDescription)")
            return
        }
        
        if (captureSession.canAddInput(videoInput)) {
            captureSession.addInput(videoInput)
        } else {
            print("Failed to add input to the capture session")
            return
        }
        
        let metadataOutput = AVCaptureMetadataOutput()
        
        if (captureSession.canAddOutput(metadataOutput)) {
            captureSession.addOutput(metadataOutput)
            
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            print("Failed to add output to the capture session")
            return
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(previewLayer)
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView = UIView()
        
        if let qrCodeFrameView = qrCodeFrameView {
            qrCodeFrameView.layer.borderColor = UIColor.clear.cgColor
            qrCodeFrameView.layer.borderWidth = 2
            view.addSubview(qrCodeFrameView)
            view.bringSubviewToFront(qrCodeFrameView)
        }
        
        // Initialize Scanning Square
        scanningSquare = UIView()
        scanningSquare.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        scanningSquare.center = view.center
        scanningSquare.layer.borderColor = UIColor.green.cgColor
        scanningSquare.layer.borderWidth = 4
        scanningSquare.layer.cornerRadius = 8
        view.addSubview(scanningSquare)
        view.bringSubviewToFront(scanningSquare)
        
        // Start the scanning animation
        startScanningAnimation()
        
        captureSession.startRunning()
        let cancelButton = UIButton(type: .system)
        cancelButton.setTitle("X", for: .normal)
        cancelButton.backgroundColor = .white
        cancelButton.titleLabel?.textColor = .black
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        cancelButton.frame = CGRect(x: 20, y: 50, width: 40, height: 40)
        cancelButton.layer.cornerRadius = cancelButton.frame.width / 2 // Make it circular
        cancelButton.clipsToBounds = true // Ensure the content is clipped to the rounded corners
        cancelButton.layer.borderWidth = 1 // Add border for better visibility
        cancelButton.layer.borderColor = UIColor.white.cgColor
        view.addSubview(cancelButton)
    }
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if (captureSession.isRunning == true) {
            captureSession.stopRunning()
        }
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if metadataObjects.isEmpty {
            qrCodeFrameView?.frame = CGRect.zero
            return
        }
        
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
            guard let stringValue = readableObject.stringValue else { return }
            
            // Transform the metadata object so that it is relative to the preview layer coordinates
            let barCodeObject = previewLayer?.transformedMetadataObject(for: readableObject)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            found(code: stringValue)
        }
        
        captureSession.stopRunning()
        stopScanningAnimation()
    }
    
    func found(code: String) {
        // Present an alert with the found QR code and a "Copy Text" button
        let alert = UIAlertController(title: "", message: code, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Search Text", style: .default, handler: { _ in
            UIPasteboard.general.string = code
            
            self.delegate?.setTextFromQRScanner(text: code)
            self.dismiss(animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
            DispatchQueue.global(qos: .background).async {
                // Start the capture session on a background thread
                self.captureSession.startRunning()
                self.startScanningAnimation()
            }
            
        }))
        present(alert, animated: true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    func startScanningAnimation() {
        UIView.animate(withDuration: 1.0, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.scanningSquare.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: nil)
    }
    
    func stopScanningAnimation() {
        scanningSquare.layer.removeAllAnimations()
        scanningSquare.transform = .identity
    }
}
