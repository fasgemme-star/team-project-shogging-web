package client.usermain;

public class RangeDTO {

	private int currentPage;  
    private int pageScale;     

    private int startNum;
    private int endNum;

    private String searchType;
    private String keyword;

	
	public RangeDTO() {
		super();
	}


	public RangeDTO(int currentPage, int pageScale, int startNum, int endNum, String searchType, String keyword) {
		super();
		this.currentPage = currentPage;
		this.pageScale = pageScale;
		this.startNum = startNum;
		this.endNum = endNum;
		this.searchType = searchType;
		this.keyword = keyword;
	}


	public int getCurrentPage() {
		return currentPage;
	}


	public void setCurrentPage(int currentPage) {
		this.currentPage = currentPage;
	}


	public int getPageScale() {
		return pageScale;
	}


	public void setPageScale(int pageScale) {
		this.pageScale = pageScale;
	}


	public int getStartNum() {
		return startNum;
	}


	public void setStartNum(int startNum) {
		this.startNum = startNum;
	}


	public int getEndNum() {
		return endNum;
	}


	public void setEndNum(int endNum) {
		this.endNum = endNum;
	}


	public String getSearchType() {
		return searchType;
	}


	public void setSearchType(String searchType) {
		this.searchType = searchType;
	}


	public String getKeyword() {
		return keyword;
	}


	public void setKeyword(String keyword) {
		this.keyword = keyword;
	}


	@Override
	public String toString() {
		return "RangeDTO [currentPage=" + currentPage + ", pageScale=" + pageScale + ", startNum=" + startNum
				+ ", endNum=" + endNum + ", searchType=" + searchType + ", keyword=" + keyword + "]";
	}
	
	
	
	
}
