class UnbordingContent {
  String image;
  String title;
  String discription;

  UnbordingContent({required this.image, required this.title, required this.discription});
}

List<UnbordingContent> contents = [
  UnbordingContent(
      title: 'Subscription Benefits',
      image: 'assets/images/intro_a.png',
      discription: "-Cashback upto 25% on each transaction\n"
                   "-Scan and pay at our listed merchants\n"
                   "-Instant Top Up Wallet of INR50/-\n"
                   "-SPENDING IS NOW REWARDING!\n"
  ),
  UnbordingContent(
      title: 'Become Merchants',
      image: 'assets/images/intro_b.png',
      discription: "-Spendzz Help your business to grow\n"
                   "-Boost and market your business through various\n strategies by choosing us.\n"
                   "-Available at different segments in market in \n  different vicinity by providing Exclusivity.\n"
  ),
  UnbordingContent(
      title: 'East Payment Features',
      image: 'assets/images/intro_c.png',
      discription: "-Accepting different modes to transfer the money \n in wallet instantly.\n"
                   "-Scanning QR code to pay instantly at our \n merchants\n"
                   "-Send and receive payments 24X7\n"
                   "-Safe and Secure transaction with SPENDZZ.\n"
  ),
  UnbordingContent(
      title: 'Refer & Earn',
      image: 'assets/images/intro_c.png',
      discription: "-Refer a friend and earn INR100Rs in your wallet while they purchase our subscription through your referral code."

  ),
];